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

  -- [[ Auto-reload externally changed files ]]
  local auto_reload_group = vim.api.nvim_create_augroup('auto-reload', { clear = true })

  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
    desc = 'Check for external file changes and reload',
    group = auto_reload_group,
    callback = function()
      if vim.fn.mode() ~= 'c' then
        vim.cmd('checktime')
      end
    end,
  })

  -- Notify when file is reloaded from external changes
  vim.api.nvim_create_autocmd('FileChangedShellPost', {
    desc = 'Notify when file is reloaded due to external changes',
    group = auto_reload_group,
    callback = function()
      vim.notify('File reloaded: ' .. vim.fn.expand('%:t'), vim.log.levels.INFO)
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
      if client and client:supports_method('textDocument/foldingRange') and client.name ~= 'metals' then -- metals.nvim does not support foldexpr for now
        local win = vim.api.nvim_get_current_win()
        print(client.name .. '\n')
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

M.telescope = function()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopeFindPre',
    desc = 'Fix telescope border display',
    group = vim.api.nvim_create_augroup('telescope-border-display', { clear = true }),
    callback = function()
      vim.opt_local.winborder = 'none'
      vim.api.nvim_create_autocmd('WinLeave', {
        once = true,
        callback = function()
          vim.opt_local.winborder = 'rounded'
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

M.persisted = function()
  local persisted_group = vim.api.nvim_create_augroup('persisted_custom', { clear = true })

  -- close non-regular files before session save
  vim.api.nvim_create_autocmd('User', {
    pattern = 'PersistedSavePre',
    desc = 'close non-regular file buffers before session save',
    group = persisted_group,
    callback = function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
          local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
          local bufname = vim.api.nvim_buf_get_name(buf)

          -- Keep only regular files: empty buftype, has real path, exists on disk, not a directory
          local is_regular_file = buftype == ''
            and bufname ~= ''
            and vim.fn.filereadable(bufname) == 1
            and vim.fn.isdirectory(bufname) == 0

          if not is_regular_file then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
      end
    end,
  })

  -- Auto-load session after full initialization
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    desc = 'auto-load session for current directory after full initialization',
    once = true,
    group = persisted_group,
    callback = function()
      if vim.g.started_with_stdin then
        return
      end

      vim.schedule(function()
        local persisted = require('persisted')
        persisted.load()
      end)
    end,
  })

  -- automatically start recording when second buf is added
  vim.api.nvim_create_autocmd('BufAdd', {
    desc = 'start recording session automatically',
    once = true,
    group = persisted_group,
    callback = function()
      vim.schedule(function()
        if vim.g.persisting == nil then
          vim.cmd('SessionStart')
          vim.notify('Start Recording session ...', vim.log.levels.INFO)
        end
      end)
    end,
  })

  -- notify when a session is deleted
  vim.api.nvim_create_autocmd('User', {
    pattern = 'PersistedDeletePost',
    desc = 'notify on deleting a session',
    group = persisted_group,
    callback = function()
      vim.notify('Session deleted', vim.log.levels.INFO)
    end,
  })

  -- notify when a session is loaded
  vim.api.nvim_create_autocmd('User', {
    pattern = 'PersistedLoadPost',
    desc = 'notify on loading a session',
    group = persisted_group,
    callback = function()
      vim.notify('Session restored for ' .. vim.fn.getcwd(), vim.log.levels.INFO)

      -- continue to record the session
      vim.cmd('SessionStart')
    end,
  })
end

return M
