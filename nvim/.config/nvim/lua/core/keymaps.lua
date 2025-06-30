--[[
--    Basic idea of keymap design:
--    1. all the usr configure functions and utils: "<leader>..."
--    2. window and buffer navigation: "<C->"
--      move-window: <C-hjkl>
--      move-buffer: <C-pn>
--      delete_window: "<leader>wd"
--      delete-buffer: "<leader>bd"
--      zoom: <C-z>
--    3. change layout(such as term toggle): ";..."
--      split: ";-" and ";\"
--      toggle_in_split: ";<lowerCaseLetter>"
--      toggle_in_float: ";<UpperCaseLetter>"
--]]

-- stylua: ignore start
local spec = {
  { '<leader>w', group = '[W]indow' },
  { '<leader>b', group = '[B]uffer' },
  { '<leader>s', group = '[S]earch' },
  { '<leader>g', group = '[G]it' },

  { '<leader>t', group = '[T]erminal' },
  { '<leader>l', group = '[L]SP' },
  { '<leader>d', group = '[D]ap' },
  { '<leader>f', group = '[F]ormat' },

  { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },

  { '<leader>a', group = '[A]I' },

  { '<leader>p', group = '[P]lugin' },
}
-- stylua: ignore end

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

-- stylua: ignore start

-- [[ Navigation and Layout ]]
-- window operation
--  See `:help wincmd` for a list of all window commands
kmap('native', 'n',  '<localleader>-',  ':split<CR>', { desc = 'split horizontal'       })
kmap('native', 'n', '<localleader>\\', ':vsplit<CR>', { desc = 'split vertical'         })
kmap('native', 'n',  '<localleader>q',      '<C-w>q', { desc = '[q]uit window'          })
kmap('native', 'n',           '<C-h>',      '<C-w>h', { desc = 'change to left window'  })
kmap('native', 'n',           '<C-j>',      '<C-w>j', { desc = 'change to lower window' })
kmap('native', 'n',           '<C-k>',      '<C-w>k', { desc = 'change to upper window' })
kmap('native', 'n',           '<C-l>',      '<C-w>l', { desc = 'change to right window' })

-- buffer operation
kmap('bufferline', 'n',      '<C-p>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer'      })
kmap('bufferline', 'n',      '<C-n>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer'      })
kmap('bufferline', 'n', '<leader>bh',  '<cmd>BufferLineMovePrev<cr>', { desc = 'Move buffer prev' })
kmap('bufferline', 'n', '<leader>bl',  '<cmd>BufferLineMoveNext<cr>', { desc = 'Move buffer next' })
kmap('snacks', 'n', '<localleader><S-q>', function() require('snacks').bufdelete() end, { desc = '[Q]uit buffer' })

-- text navigation
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

-- file navigation
kmap('neo-tree', 'n', '<localleader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle [e]xplorer' })
kmap('neo-tree', 'n', '<localleader>l', '<Cmd>Neotree reveal<CR>', { desc = '[l]ocate file' })
-- search and goto files (<leader>s, <leader>g)
-- See `:help telescope.builtin`
kmap('telescope', 'n', '<leader>sf', function() require('telescope.builtin').find_files()                end, { desc = '[f]iles' })
kmap('telescope', 'n', '<leader>s.', function() require('telescope.builtin').oldfiles()                  end, { desc = 'recent Files' })
kmap('telescope', 'n', '<leader>sw', function() require('telescope.builtin').grep_string()               end, { desc = 'current [w]ord' })
kmap('telescope', 'n', '<leader>sh', function() require('telescope.builtin').help_tags()                 end, { desc = '[h]elp' })
kmap('telescope', 'n', '<leader>sk', function() require('telescope.builtin').keymaps()                   end, { desc = '[k]eymaps' })
kmap('telescope', 'n', '<leader>sa', function() require('telescope.builtin').live_grep()                 end, { desc = '[a]ll workspace' })
kmap('telescope', 'n', '<leader>sr', function() require('telescope.builtin').resume()                    end, { desc = '[r]esume' })
kmap('telescope', 'n', '<leader>sn', function() require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') }) end, { desc = '[n]eovim files' })
kmap('telescope', 'n', '<leader>sb', function() require('telescope.builtin').current_buffer_fuzzy_find() end, { desc = 'in current [b]uffer' })

-- toggle full screen
kmap('snacks', { 'n', 't' }, '<C-z>', function() require('custom.zoom-win')() end, { desc = 'Toggle window fullscreen' })

-- [[ Terminal <leader>t ]]
kmap('snacks', 'n', '<leader>tt', function() require('custom.terminal').create_term_cur() end, { desc = 'Create terminal (current dir)' })
kmap('snacks', 'n', '<leader>tT', function() require('custom.terminal').create_term_root() end, { desc = 'Create terminal (workspace root)' })
kmap('snacks', 'n', '<localleader>t', function() require('custom.terminal').toggle_opened_term() end, { desc = 'Toggle [t]erminals' })
kmap('snacks', 'n', '<localleader>T', function() require('custom.terminal').toggle_float_term() end, { desc = 'Create floating [T]erminal' })

-- [[ Git ]]
kmap('snacks', 'n', '<localleader>g', function() require('snacks').lazygit.open() end, { desc = 'Toggle lazy[g]it' })
kmap('snacks', 'n', '<leader>gb', function() require('snacks').git.blame_line() end, { desc = '[B]lame line' })

-- [[ LSP ]]
-- diagnostic
kmap('lsp',     'n', '<leader>ll', vim.diagnostic.setloclist,               { desc = 'Lsp: quickfix [l]ist' })
kmap('lspsaga', 'n', '<leader>ln', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { desc = 'Lsp: [n]ext diagnostic' })
kmap('lspsaga', 'n', '<leader>lp', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = 'Lsp: [p]rev diagnostic' })
-- display info
kmap('lspsaga', 'n', '<leader>li', '<Cmd>Lspsaga hover_doc<CR>',   { desc = 'Lsp: hover [i]nformation' })
kmap('lspsaga', 'n', '<localleader>s', '<Cmd>Lspsaga outline<CR>', { desc = 'Toggle file [s]tructure' })
-- search and jump
kmap('lspsaga', 'n', '<leader>ld', '<Cmd>Lspsaga goto_definition<CR>', { desc = 'Lsp: [d]efinition' }) --  To jump back, press <C-t>.
kmap('lspsaga', 'n', '<leader>lv', '<Cmd>Lspsaga peek_definition<CR>', { desc = 'Lsp: [v]iew definition' })
kmap('lspsaga', 'n', '<leader>lf', '<Cmd>Lspsaga finder<CR>',          { desc = 'Lsp: [f]ind references' })
-- code actions
kmap('lspsaga', 'n', '<leader>lr', '<Cmd>Lspsaga rename<CR>',      { desc = 'Lsp: [r]eame' })
kmap('lspsaga', 'n', '<leader>la', '<Cmd>Lspsaga code_action<CR>', { desc = 'Lsp: code [a]ction' })

-- [[ Debug <leader>d ]]
kmap('nvim-dap', 'n', '<localleader>d', function() require('dapui').toggle() end, { desc = 'Toggle DAP UI' })
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

-- [[ Format ]]
kmap('conform', 'n', '<leader>fd', '<cmd>FormatDisable<CR>', { desc = '[d]isable format' })
kmap('conform', 'n', '<leader>fe', '<cmd>FormatEnable<CR>', { desc = '[e]nable format' })

-- [[ Code ]]
kmap('native', 'n', '<leader>cc', 'gcc', { desc = 'Toggle [c]omment', remap = true })
kmap('native', 'v', '<leader>cc', 'gc', { desc = 'Toggle [c]omment', remap = true })
-- folding
kmap('native', 'n', '<localleader>o', 'zo', { desc = '[o]pen sub fold' })
kmap('native', 'n', '<localleader>f', 'zc', { desc = '[f]old sub fold' })
kmap('native', 'n', '<localleader>O', 'zO', { desc = '[O]pen top fold' })
kmap('native', 'n', '<localleader>F', 'zC', { desc = '[F]old top fold' })

-- [[ AI ]]
-- use codecompanion
-- kmap('codecompanion', { 'n', 'v' }, '<localleader>a', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'Toggle a[i]' })
-- kmap('codecompanion', { 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionActions<cr>', { desc = 'AI: [a]ctions' })
-- kmap('codecompanion', 'v', '<leader>as', '<cmd>CodeCompanionChat Add<cr>', { desc = 'AI: [s]elect' })
-- use avante
-- kmap('avante', { 'n', 'v' }, '<localleader>a', '<cmd>AvanteToggle<cr>', { desc = 'Toggle [A]I' })
-- use gemini-cli
-- kmap('native', 'n', '<localleader>a', function() require('snacks').terminal.toggle('source ~/.nvm/nvm.sh && gemini', { cwd = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd(), start_insert = true, auto_insert = false, auto_close = true, }) end, { desc = 'Run gemini in root terminal' })
-- use claude-code
kmap('native', 'n', '<localleader>a', function() require('snacks').terminal.toggle('source ~/.nvm/nvm.sh && claude', { cwd = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd(), start_insert = true, auto_insert = false, auto_close = true, }) end, { desc = 'Run Claude in root terminal' })

-- [[ Notifications ]]
kmap('noice', 'n', '<leader>sn', function() require('noice').cmd('telescope') end, { desc = '[N]otices'})

-- [[ Plugins ]]
kmap('lazy', 'n', '<leader>pp', '<cmd>Lazy<CR>', { desc = 'view [p]lugins' })
kmap('lsp', 'n', '<leader>pl', '<cmd>checkhealth vim.lsp<CR>', { desc = 'check [l]sp' })
kmap('mason', 'n', '<leader>pm', '<cmd>Mason<CR>', { desc = 'open [m]ason' })
kmap('conform', 'n', '<leader>pc', '<cmd>ConformInfo<CR>', { desc = 'check [c]onform' })

-- [[ Miscellaneous ]]
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
kmap('native', 'n', '<Esc>', '<cmd>nohlsearch<CR>')
-- use <Esc> to quit terminal mode
kmap('native', 't', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- use <C-s> to save file
kmap('native', 'n', '<C-s>', ':w<CR>', { desc = '[f]ile [s]ave' })

-- stylua: ignore end

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
