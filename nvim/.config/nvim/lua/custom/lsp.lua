-- [[ enable LSP before loading plugins ]]

-- LSP servers to enable
local lsp_servers = {
  'lua_ls',
  'clangd',
  'svlangserver',
  -- 'pylsp', -- too slow
  -- 'jedi-language-server', -- too slow
  -- 'basedpyright', -- too slow
  -- 'pyrefly', -- missing features
  -- 'ty', -- missing features (promissing)
  'pyright', -- microsoft-default-lsp
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
