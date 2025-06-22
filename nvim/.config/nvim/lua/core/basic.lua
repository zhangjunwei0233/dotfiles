-- [[ Global variables ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Vim Options ]]
-- See `:help vim.opt`
-- For more options, you can see `:help option-list`

-- Set gui nerdfont
vim.opt.guifont = 'JetBrainsMono Nerd Font:h17'
vim.opt.linespace = 0

-- open float window with single border
vim.opt.winborder = 'rounded'

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Don't wrap long lines, since it reduces readability
vim.opt.wrap = false
-- keep indent for wrapped lines
vim.opt.breakindent = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'

  if vim.fn.has('wsl') then
    vim.cmd([[
      let g:clipboard = {
      \   'name': 'WslClipboard',
      \   'copy': {
      \     '+': 'clip.exe',
      \     '*': 'clip.exe',
      \   },
      \   'paste': {
      \     '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      \     '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      \   },
      \   'cache_enabled': 0,
      \ }
    ]])
  end
end)

-- set indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0 -- match tabstop

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- always leave space for signcolumn
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 500

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
-- vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- keep status bar only for current window
vim.opt.laststatus = 3
