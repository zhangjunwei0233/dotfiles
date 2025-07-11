-- [[ enable LSP before loading plugins ]]

-- LSP servers to enable
local lsp_servers = {
  'lua_ls',
  'clangd',
  'svlangserver',
  'pylsp', -- feature-rich-lsp
  -- 'pyright', -- microsoft-default-lsp
  -- 'ruff', -- linter and formatter
}

-- Enable LSP servers with error handling
for _, server in ipairs(lsp_servers) do
  local ok, err = pcall(vim.lsp.enable, server)
  if not ok then
    vim.notify(string.format('Failed to enable LSP server "%s": %s', server, err), vim.log.levels.WARN)
  end
end

-- [[ load autocmds ]]
require('core.utils').load_plugin_autocmds('lsp')

-- [[ load keymaps ]]
require('core.utils').setup_keymaps('lsp')
