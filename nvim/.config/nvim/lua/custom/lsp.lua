-- [[ enable LSP before loading plugins ]]
vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('svlangserver')
-- chose one for python
vim.lsp.enable('pylsp') -- feature-rich
-- vim.lsp.enable('pyright') -- microsoft-default

-- [[ setup native diagnostic config ]]
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

-- [[ load keymaps ]]
local keymaps = require('core.keymaps').lsp
if keymaps then
  keymaps()
else
  vim.notify('lsp loaded without keymap\n', vim.log.levels.WARN)
end
