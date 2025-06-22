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

  -- [[ change *.v files to filetype 'verilog' ]]
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'v',
    group = vim.api.nvim_create_augroup('verilog_ft', { clear = true }),
    callback = function()
      vim.bo.filetype = 'verilog'
    end,
    desc = 'auto set v filetype to verilog',
  })
end

M.foldings = function()
  -- [[ use lsp to fold code ]]
  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'switch to lsp to provide folding method',
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/foldingRange') then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end
    end,
  })
end

M.telescope = function()
  -- [[ Fix telescope border display ]]
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopeFindPre',
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

return M
