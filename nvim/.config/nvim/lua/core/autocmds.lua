local M = {}

M.native = function()
  -- [[ Highlight when yanking (copying) text ]]
  --  Try it with `yap` in normal mode
  --  See `:help vim.highlight.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-on-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })
end

M.foldings = function()
  -- [[ use lsp to fold code ]]
  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'switch to lsp to provide folding method',
    group = vim.api.nvim_create_augroup('lsp-fold', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/foldingRange') then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end
    end,
  })
end

M.lspsaga = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sagaoutline',
    desc = 'quit sagaoutline one leaving sagaoutline window',
    group = vim.api.nvim_create_augroup('lspsaga-outline-autoquit', { clear = true }),
    callback = function()
      vim.api.nvim_create_autocmd('WinLeave', {
        once = true,
        callback = function()
          vim.schedule(function() -- use schedule to make sure all the previews are also closed
            vim.cmd('Lspsaga outline') -- close outline
          end)
        end,
      })
    end,
  })
end

M.lsp = function()
  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'lsp setups',
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      -- obtain LSP client
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      -- [diagnostics]
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      -- [highlight words under cursor]
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = true })

        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_group,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_group,
          callback = vim.lsp.buf.clear_references,
        })
      end

      -- [offloads upon detachment]
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event.buf })
        end,
      })
    end,
  })
end

return M
