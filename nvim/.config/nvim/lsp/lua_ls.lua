return { -- copied from nvim-lspconfig
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }, -- manually set vim to global to get rid of the annoying warning
      },
    },
  },
}
