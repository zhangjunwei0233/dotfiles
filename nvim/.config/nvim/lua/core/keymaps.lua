--[[
--    Basic idea of keymap design:
--    1. all the usr configure functions and utils: "<leader>..."
--    2. window and buffer navigation: "<C->"
--      move-window: <C-hjkl>
--      move-buffer: <C-[]>
--      delete_window: "<leader>wd"
--      delete-buffer: "<leader>bd"
--      zoom: <C-z>
--    3. change layout(such as term toggle): ";..."
--      split: ";-" and ";\"
--      toggle_in_split: ";<lowerCaseLetter>"
--      toggle_in_float: ";<UpperCaseLetter>"
--]]

local spec = {
  { '<leader>c', group = '[c]ode', mode = { 'n', 'x' } },
  { '<leader>l', group = '[l]SP' },
  { '<leader>f', group = '[F]ormat' },
  { '<leader>d', group = '[D]ap' },
  { '<leader>b', group = '[B]uffer' },
  { '<leader>w', group = '[W]indow' },
  { '<leader>s', group = '[s]earch' },
  { '<leader>g', group = '[g]oto' },
  { '<leader>t', group = '[t]erminal' },
  { '<leader>p', group = '[p]lugin' },
  { '<leader>i', group = 'a[i]' },
}

-- [[ Set a function to configure keymaps ]]
local map_table = {}
local function kmap(plugin, mode, lhs, rhs, opts)
  -- create keymap function
  local map = function()
    local options = { noremap = true, silent = true }
    if opts then
      options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
  end

  -- insert into map_table
  if not map_table[plugin] then
    map_table[plugin] = {}
  end
  table.insert(map_table[plugin], map)
end

-- [[ Navigation and Layout ]]
-- window operation
--  See `:help wincmd` for a list of all window commands
kmap('native', 'n', '<localleader>-', ':split<CR>', { desc = 'split horizontal' })
kmap('native', 'n', '<localleader>\\', ':vsplit<CR>', { desc = 'split vertical' })
kmap('native', 'n', '<localleader>q', '<C-w>q', { desc = 'delete window' })
kmap('native', 'n', '<C-h>', '<C-w>h', { desc = 'change to left window' })
kmap('native', 'n', '<C-j>', '<C-w>j', { desc = 'change to lower window' })
kmap('native', 'n', '<C-k>', '<C-w>k', { desc = 'change to upper window' })
kmap('native', 'n', '<C-l>', '<C-w>l', { desc = 'change to right window' })

-- buffer operation
kmap('bufferline', 'n', '<C-[>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer' })
kmap('bufferline', 'n', '<C-]>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })
kmap('bufferline', 'n', '<leader>bh', '<cmd>BufferLineMovePrev<cr>', { desc = 'Move buffer prev' })
kmap('bufferline', 'n', '<leader>bl', '<cmd>BufferLineMoveNext<cr>', { desc = 'Move buffer next' })
kmap('snacks', 'n', '<localleader><S-q>', function()
  require('snacks').bufdelete()
end, { desc = '[D]elete buffer' })

-- in-file navigation
kmap('hop', { 'n', 'v' }, 'f', function()
  require('hop').hint_char1({
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    current_line_only = false,
  })
end, { desc = 'hop forward', remap = true })
kmap('hop', { 'n', 'v' }, 'F', function()
  require('hop').hint_char1({
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    current_line_only = false,
  })
end, { desc = 'hop backward', remap = true })

-- explorer
kmap('neo-tree', 'n', '<localleader>e', '<Cmd>Neotree toggle<CR>', { desc = 'NeoTree toggle' })
kmap('neo-tree', 'n', '<localleader>f', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal' })

-- toggle terminal
kmap( -- Toggle all terminals
  'snacks',
  'n',
  '<localleader>t',
  function()
    local terms = require('snacks').terminal.list()
    local any_visible = false
    for _, term in ipairs(terms) do
      if term.win and vim.api.nvim_win_is_valid(term.win) then
        any_visible = true
        break
      end
    end
    for _, term in ipairs(terms) do
      if any_visible then
        term:hide()
      else
        term:show()
      end
    end
  end,
  { desc = 'Toggle all terminals' }
)
kmap('snacks', 'n', '<localleader>T', function()
  require('snacks').terminal.toggle(vim.o.shell, {
    win = {
      relative = 'editor',
      style = 'terminal', -- Use terminal style from config
    },
  })
end, { desc = 'Create floating terminal' })

-- toggle dapui
kmap('nvim-dap', 'n', '<localleader>d', function()
  require('dapui').toggle()
end, { desc = 'Toggle DAP UI' })

-- toggle lazygit: using snacks.lazygit
kmap('snacks', 'n', '<localleader>g', function()
  require('snacks').lazygit.open()
end, { desc = '[t]oggle lazy[g]it' })

-- toggle full screen
local snacks_win = nil
kmap('snacks', { 'n', 't' }, '<C-z>', function()
  local current_win = vim.api.nvim_get_current_win()
  -- Close if already in snacks window
  if snacks_win and snacks_win:win_valid() and snacks_win.win == current_win then
    snacks_win:close()
    snacks_win = nil
    return
  end
  -- Close previous instance
  if snacks_win and snacks_win:win_valid() then
    snacks_win:close()
    snacks_win = nil
  end
  -- Get current buffer from active window
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  -- Create window with current buffer
  snacks_win = require('snacks').win({
    buf = current_buf,
    width = 0.99,
    height = 0.99,
    border = 'rounded',
    wo = {
      spell = false,
      wrap = false,
      number = true,
      relativenumber = true,
      scrollbind = true,
      cursorbind = true,
    },
    on_win = function()
      vim.wo[current_win].scrollbind = true
      vim.wo[current_win].cursorbind = true
    end,
    on_close = function()
      vim.wo[current_win].scrollbind = false
      vim.wo[current_win].cursorbind = false
    end,
  })
end, { desc = 'Toggle window fullscreen' })

-- [[ LSP ]]
-- diagnostic
kmap('lsp', 'n', '<leader>ll', vim.diagnostic.setloclist, { desc = 'Open [L]sp quickfix [l]ist' })
kmap('lspsaga', 'n', '<leader>ln', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { desc = '[N]ext diagnostic' })
kmap('lspsaga', 'n', '<leader>lp', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = '[P]rev diagnostic' })
-- display info
kmap('lspsaga', 'n', '<leader>li', '<Cmd>Lspsaga hover_doc<CR>', { desc = 'hover [I]nformation' })
kmap('lspsaga', 'n', '<localleader>o', '<Cmd>Lspsaga outline<CR>', { desc = 'toggle [O]utline' })
-- search and jump
kmap('lspsaga', 'n', '<leader>ld', '<Cmd>Lspsaga goto_definition<CR>', { desc = '[d]efinition' }) --  To jump back, press <C-t>.
kmap('lspsaga', 'n', '<leader>lv', '<Cmd>Lspsaga peek_definition<CR>', { desc = '[V]iew definition' })
kmap('lspsaga', 'n', '<leader>lf', '<Cmd>Lspsaga finder<CR>', { desc = '[F]ind references' })
-- code actions
kmap('lspsaga', 'n', '<leader>lr', '<Cmd>Lspsaga rename<CR>', { desc = '[R]eame' })
kmap('lspsaga', 'n', '<leader>la', '<Cmd>Lspsaga code_action<CR>', { desc = 'code [A]ction' })

-- [[ Format ]]
kmap('conform', 'n', '<leader>fd', '<cmd>FormatDisable<CR>', { desc = '[F]ormat [Disable]' })
kmap('conform', 'n', '<leader>fe', '<cmd>FormatEnable<CR>', { desc = '[F]ormat [Disable]' })

-- [[ Telescope (<leader>s, <leader>g) ]]
-- See `:help telescope.builtin`
-- stylua: ignore start
kmap('telescope', 'n', '<leader>gf', function() require('telescope.builtin').find_files() end, { desc = '[g]oto [f]iles' })
kmap('telescope', 'n', '<leader>g.', function() require('telescope.builtin').oldfiles() end, { desc = '[g]oto Recent Files ("." for repeat)' })
kmap('telescope', 'n', '<leader>sw', function() require('telescope.builtin').grep_string() end, { desc = '[s]earch current [w]ord' })
kmap('telescope', 'n', '<leader>sh', function() require('telescope.builtin').help_tags() end, { desc = '[s]earch [h]elp' })
kmap('telescope', 'n', '<leader>sk', function() require('telescope.builtin').keymaps() end, { desc = '[s]earch [k]eymaps' })
kmap('telescope', 'n', '<leader>sa', function() require('telescope.builtin').live_grep() end, { desc = '[s]earch [a]ll workspace by grep' })
kmap('telescope', 'n', '<leader>sr', function() require('telescope.builtin').resume() end, { desc = '[s]earch [r]esume' })
kmap('telescope', 'n', '<leader>gn', function() require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') }) end, { desc = '[g]oto [n]eovim files' })
kmap('telescope', 'n', '<leader>sb', function() require('telescope.builtin').current_buffer_fuzzy_find() end, { desc = '[s]earch in current [b]uffer fuzzily' })
-- stylua: ignore end

-- [[ File (<leader>f) ]]
kmap('native', 'n', '<C-s>', ':w<CR>', { desc = '[f]ile [s]ave' })

-- [[ Code ]]
kmap('native', 'n', '<leader>cc', 'gcc', { desc = '[c]ode toggle [c]omment', remap = true })
kmap('native', 'v', '<leader>cc', 'gc', { desc = '[c]ode toggle [c]omment', remap = true })

-- [[ Plugins ]]
kmap('lazy', 'n', '<leader>pp', '<cmd>Lazy<CR>', { desc = 'open [P]lugins' })
kmap('lsp', 'n', '<leader>pl', '<cmd>checkhealth vim.lsp<CR>', { desc = 'open [L]sp' })
kmap('mason', 'n', '<leader>pm', '<cmd>Mason<CR>', { desc = 'open [M]ason' })
kmap('conform', 'n', '<leader>pc', '<cmd>ConformInfo<CR>', { desc = 'open [C]onform' })

-- [[ Miscellaneous ]]
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
kmap('native', 'n', '<Esc>', '<cmd>nohlsearch<CR>')
-- use <Esc> to quit terminal mode
kmap('native', 't', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ terminal (<leader>t) ]]
kmap('snacks', 'n', '<leader>tt', function()
  require('snacks').terminal.toggle(nil, {
    cwd = vim.fn.expand('%:p:h'),
    start_insert = false,
    auto_insert = false,
    auto_close = true,
  })
end, { desc = 'Toggle terminal (current dir)' })
kmap('snacks', 'n', '<leader>tT', function()
  require('snacks').terminal.toggle(nil, {
    cwd = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd(),
    start_insert = false,
    auto_insert = false,
    auto_close = true,
  })
end, { desc = 'Toggle terminal (workspace root)' })

-- [[ AI ]]
kmap('codecompanion', { 'n', 'v' }, '<localleader>i', '<cmd>CodeCompanionChat Toggle<cr>', { desc = '[t]oggle a[i]' })
kmap('codecompanion', { 'n', 'v' }, '<leader>ia', '<cmd>CodeCompanionActions<cr>', { desc = 'a[i] [a]ctions' })
kmap('codecompanion', 'v', '<leader>is', '<cmd>CodeCompanionChat Add<cr>', { desc = 'a[i] [s]elect' })

-- [[ nvim-dap (<leader>d) ]]
-- stylua: ignore start
kmap('nvim-dap', 'n', '<leader>ds', function() require('dap').continue() end, { desc = ' Start/Continue' })
kmap('nvim-dap', 'n', '<F1>',       function() require('dap').continue() end, { desc = ' Start/Continue' })
kmap('nvim-dap', 'n', '<leader>di', function() require('dap').step_into() end, { desc = ' Step into' })
kmap('nvim-dap', 'n', '<F2>',       function() require('dap').step_into() end, { desc = ' Step into' })
kmap('nvim-dap', 'n', '<leader>do', function() require('dap').step_over() end, { desc = ' Step over' })
kmap('nvim-dap', 'n', '<F3>',       function() require('dap').step_over() end, { desc = ' Step over' })
kmap('nvim-dap', 'n', '<leader>dO', function() require('dap').step_out() end, { desc = ' Step out' })
kmap('nvim-dap', 'n', '<F4>',       function() require('dap').step_out() end, { desc = ' Step out' })
kmap('nvim-dap', 'n', '<leader>dq', function() require('dap').close() end, { desc = 'DAP: Close session' })
kmap('nvim-dap', 'n', '<leader>dQ', function() require('dap').terminate() end, { desc = ' Terminate session' })
kmap('nvim-dap', 'n', '<leader>dr', function() require('dap').restart_frame() end, { desc = 'DAP: Restart' })
kmap('nvim-dap', 'n', '<F5>',       function() require('dap').restart_frame() end, { desc = 'DAP: Restart' })
kmap('nvim-dap', 'n', '<leader>dc', function() require('dap').run_to_cursor() end, { desc = 'DAP: Run to Cursor' })
kmap('nvim-dap', 'n', '<leader>dR', function() require('dap').repl.toggle() end, { desc = 'DAP: Toggle REPL' })
kmap('nvim-dap', 'n', '<leader>dh', function() require('dap.ui.widgets').hover() end, { desc = 'DAP: Hover' })
kmap('nvim-dap', 'n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'DAP: Breakpoint' })
kmap('nvim-dap', 'n', '<leader>dB', function()
  local input = vim.fn.input('Condition for breakpoint:')
  require('dap').set_breakpoint(input)
end, { desc = 'DAP: Conditional Breakpoint' })
kmap('nvim-dap', 'n', '<leader>dD', function() require('dap').clear_breakpoints() end, { desc = 'DAP: Clear Breakpoints' })
-- stylua: ignore end

-- [[ code folding ]]
-- plugin: ufo
kmap('ufo', 'n', '<leader>cO', function()
  require('ufo').openAllFolds()
end, { desc = 'open all folds' })
kmap('ufo', 'n', '<leader>cF', function()
  require('ufo').closeAllFolds()
end, { desc = 'close all folds' })
kmap('ufo', 'n', '<leader>o', 'zo', { desc = 'open sub fold' })
kmap('ufo', 'n', '<leader>f', 'zc', { desc = 'close sub fold' })
kmap('ufo', 'n', '<leader>O', 'zO', { desc = 'Open top fold' })
kmap('ufo', 'n', '<leader>F', 'zC', { desc = 'Close top fold' })

-- [[ sort keymap table and return ]]
local M = {}

for plugin, maps in pairs(map_table) do
  M[plugin] = function()
    local results = {}
    for i, map in ipairs(maps) do
      results[i] = map()
    end
    return results
  end
end

-- add specs for which-key
M.spec = spec

return M
