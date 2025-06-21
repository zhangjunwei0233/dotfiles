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

-- [[ Highlight when yanking (copying) text ]]
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ change *.v files to filetype 'verilog' ]]
vim.api.nvim_create_augroup('verilog_ft', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'auto set v filetype to verilog',
  group = 'verilog_ft',
  pattern = '*.v',
  callback = function()
    vim.bo.filetype = 'verilog'
  end,
})
