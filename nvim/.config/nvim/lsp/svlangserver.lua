return { -- copied from nvim-lspconfig
  cmd = { 'svlangserver' },
  filetypes = { 'verilog', 'systemverilog' },
  root_markers = { '.svlangserver', '.git' },
  settings = {
    systemverilog = {
      includeIndexing = { '*.{v,vh,sv,svh}', '**/*.{v,vh,sv,svh}' },
    },
  },
}
