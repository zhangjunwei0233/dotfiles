-- [[
--  Parse code to Abstract Syntax Tree (AST)
--
--  many features are based on that, such as grammar highlight,
--  symbol search, ...
-- ]]
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main modules to use for opts
  opts = {
    ensure_installed = { 'c', 'lua', 'scala', 'markdown', 'markdown_inline' },
    auto_install = true,
    highlight = { enable = true },
  },
}
