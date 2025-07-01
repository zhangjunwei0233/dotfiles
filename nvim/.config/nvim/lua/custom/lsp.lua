-- [[ enable LSP before loading plugins ]]
vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('svlangserver')
-- below are for python
vim.lsp.enable('pylsp') -- feature-rich-lsp
-- vim.lsp.enable('pyright') -- microsoft-default-lsp
-- vim.lsp.enable('ruff') -- linter and formatter

-- [[ load autocmds ]]
local autocmds = require('core.autocmds').lsp
if autocmds then
  autocmds()
end

-- [[ load keymaps ]]
local keymaps = require('core.keymaps').lsp
if keymaps then
  keymaps()
else
  vim.notify('lsp loaded without keymap\n', vim.log.levels.WARN)
end
