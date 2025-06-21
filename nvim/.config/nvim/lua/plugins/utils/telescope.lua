-- [[ Telescope: a fuzzy finder ]]
return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function() -- enable when have make
        return vim.fn.executable('make') == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup({
      -- defaults = {},
      -- pickers = {},
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- load keymaps
    local keymaps = require('core.keymaps').telescope
    if keymaps then
      keymaps()
    else
      vim.notify('telescope loaded without keymap\n', vim.log.levels.WARN)
    end

    -- fix winborder
    vim.api.nvim_create_autocmd('User', {
      pattern = 'TelescopeFindPre',
      callback = function()
        vim.opt_local.winborder = 'none'
        vim.api.nvim_create_autocmd('WinLeave', {
          once = true,
          callback = function()
            vim.opt_local.winborder = 'rounded'
          end,
        })
      end,
    })
  end,
}
