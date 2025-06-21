-- [[ Code Folding ]]
-- this plugin is currently disabled since it is too slow
-- default folding method set to treesitter in 'core.basic'
-- an antocmd is created to switch folding method to using lsp
-- on LspAttach, see core.autocmd
return {
  enabled = false,
  'kevinhwang91/nvim-ufo',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'kevinhwang91/promise-async' },
  config = function()
    -- Option 1: coc.nvim as LSP client
    -- use {'neoclide/coc.nvim', branch = 'master', run = 'yarn install --frozen-lockfile'}
    -- require('ufo').setup()

    -- Option 2: nvim lsp as LSP client
    -- Tell the server the capability of foldingRange,
    -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities.textDocument.foldingRange = {
    --   dynamicRegistration = false,
    --   lineFoldingOnly = true,
    -- }
    -- local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
    -- for _, ls in ipairs(language_servers) do
    --   require('lspconfig')[ls].setup {
    --     capabilities = capabilities,
    --     -- you can add other fields for setting up lsp server in this table
    --   }
    -- end
    -- require('ufo').setup()

    -- Option 3: treesitter as a main provider instead
    -- (Note: the `nvim-treesitter` plugin is *not* needed.)
    -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
    -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
    local ftMap = {
      vim = 'indent',
      python = { 'indent' },
      c = { 'lsp' },
      lua = { 'lsp' },
      git = '',
    }
    require('ufo').setup({
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        -- options: 'comment' | 'imports' | 'marker' | 'region'
        default = { 'imports' },
      },
      provider_selector = function(bufnr, filetype, buftype)
        return ftMap[filetype] or { 'treesitter', 'indent' }
        -- refer to ./doc/example.lua for detail
      end,
    })

    -- Option 4: disable all providers for all buffers
    -- Not recommend, AFAIK, the ufo's providers are the best performance in Neovim
    -- require('ufo').setup {
    --   provider_selector = function(bufnr, filetype, buftype)
    --     return ''
    --   end,
    -- }

    -- load kemaps
    local keymaps = require('core.keymaps').ufo
    if keymaps then
      keymaps()
    else
      vim.notify('ufo loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
