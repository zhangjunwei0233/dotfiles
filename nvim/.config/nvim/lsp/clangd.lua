return { -- copied from nvim-lspconfig
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
  root_markers = {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac', -- AutoTools
  },
  single_file_support = true,
}
