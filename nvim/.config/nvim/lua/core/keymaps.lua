--[[
--    Basic idea of keymap design:
--    1. all the usr configure functions and utils: "<leader>..."
--    2. window and buffer navigation: "<C->"
--      move-window: <C-hjkl>
--      move-buffer: <C-np>
--      zoom: <C-z>
--    3. change layout(such as term toggle): ";..."
--      split: ";-" and ";\"
--      delete_window: ";q"
--      delete-buffer: ";<S-q>"
--      toggle_in_split: ";<lowerCaseLetter>"
--      toggle_in_float: ";<UpperCaseLetter>"
--]]

-- stylua: ignore start
local M = {}

M.spec = {
  { '<leader>w', group = 'Window' },
  { '<leader>b', group = 'Buffer' },
  { '<leader>s', group = 'Search' },
  { '<leader>g', group = 'Git' },

  { '<leader>t', group = 'Terminal' },
  { '<leader>l', group = 'LSP' },
  { '<leader>d', group = 'Debug' },
  { '<leader>f', group = 'Find' },

  { '<leader>c', group = 'Code', mode = { 'n', 'x' } },

  { '<leader>s', group = 'Session' },

  { '<leader>a', group = 'AI' },

  { '<leader>p', group = 'Plugin' },
}
-- stylua: ignore end

-- [[ Set a function to configure keymaps ]]
local function kmap(plugin, mode, lhs, rhs, opts)
  -- create keymap entry in lazy.nvim format
  local entry = {
    lhs,
    rhs,
    mode = mode,
  }
  -- merge options
  if opts then
    entry = vim.tbl_extend('force', entry, opts)
  end
  -- ensure defaults
  if not entry.noremap then
    entry.noremap = true
  end
  if not entry.silent then
    entry.silent = true
  end

  -- insert into map_table
  if not M[plugin] then
    M[plugin] = {}
  end
  table.insert(M[plugin], entry)
end

-- stylua: ignore start

-- NOTE: [[ Navigation and Layout ]]

-- [ window operation ]
--  See `:help wincmd` for a list of all window commands
kmap('native', {'n', 't'},  '<localleader>-',  '<Cmd>split<CR>', { desc = 'split horizontal'       })
kmap('native', {'n', 't'}, '<localleader>\\', '<Cmd>vsplit<CR>', { desc = 'split vertical'         })
kmap('native', {'n', 't'},  '<localleader>q',      '<Cmd>wincmd q<CR>', { desc = '[q]uit window'          })
kmap('native', {'n', 't'},           '<C-h>',      '<Cmd>wincmd h<CR>', { desc = 'change to left window'  })
kmap('native', {'n', 't'},           '<C-j>',      '<Cmd>wincmd j<CR>', { desc = 'change to lower window' })
kmap('native', {'n', 't'},           '<C-k>',      '<Cmd>wincmd k<CR>', { desc = 'change to upper window' })
kmap('native', {'n', 't'},           '<C-l>',      '<Cmd>wincmd l<CR>', { desc = 'change to right window' })

-- [ buffer operation ]
kmap('bufferline', 'n',      '<C-n>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer'      })
kmap('bufferline', 'n',      '<C-p>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer'      })
kmap('bufferline', 'n', '<leader>bh',  '<cmd>BufferLineMovePrev<cr>', { desc = 'Move buffer prev' })
kmap('bufferline', 'n', '<leader>bl',  '<cmd>BufferLineMoveNext<cr>', { desc = 'Move buffer next' })
kmap('snacks', 'n', '<localleader><S-q>', function() require('snacks').bufdelete() end, { desc = '[Q]uit buffer' })

-- [ text navigation ]
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

-- [ file navigation ]
-- option 1: neo-tree
-- kmap('neo-tree', 'n', '<localleader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle [e]xplorer' })
-- kmap('neo-tree', 'n', '<localleader>l', '<Cmd>Neotree reveal<CR>', { desc = '[l]ocate file' })
-- option 2: snacks.explorer
kmap('snacks', 'n', '<localleader>e', function() require('snacks').explorer.open() end, { desc = 'Toggle [e]xplorer' })

-- [ search and goto files <leader>f ]
-- OPTION1: use telescope
-- See `:help telescope.builtin`
-- kmap('telescope', 'n', '<leader>ff', function() require('telescope.builtin').find_files()                end, { desc = '[f]iles' })
-- kmap('telescope', 'n', '<leader>f.', function() require('telescope.builtin').oldfiles()                  end, { desc = 'recent files' })
-- kmap('telescope', 'n', '<leader>fw', function() require('telescope.builtin').grep_string()               end, { desc = '[w]ord under cursor' })
-- kmap('telescope', 'n', '<leader>fh', function() require('telescope.builtin').help_tags()                 end, { desc = '[h]elp' })
-- kmap('telescope', 'n', '<leader>fk', function() require('telescope.builtin').keymaps()                   end, { desc = '[k]eymaps' })
-- kmap('telescope', 'n', '<leader>fa', function() require('telescope.builtin').live_grep()                 end, { desc = '[a]ll workspace' })
-- kmap('telescope', 'n', '<leader>fr', function() require('telescope.builtin').resume()                    end, { desc = '[r]esume' })
-- kmap('telescope', 'n', '<leader>fc', function() require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') }) end, { desc = 'nvim [c]onfig files' })
-- kmap('telescope', 'n', '<leader>fl', function() require('telescope.builtin').current_buffer_fuzzy_find() end, { desc = 'in current [b]uffer' })

-- OPTION2: use snacks.picker
kmap('snacks', 'n', '<leader>fp', function() require('snacks').picker() end, { desc = 'Select any [P]icker'} )
kmap('snacks', 'n', '<leader>ff', function() require('snacks').picker.smart() end, { desc = 'Smart find [F]ile'} )
kmap('snacks', 'n', '<leader>f.', function() require('snacks').picker.recent() end, { desc = 'Find recent file'} )
kmap('snacks', 'n', '<leader>fw', function() require('snacks').picker.grep_word() end, { desc = 'Find [w]ord under cursor'} )
kmap('snacks', 'n', '<leader>fh', function() require('snacks').picker.help() end, { desc = 'Find [H]elp'} )
kmap('snacks', 'n', '<leader>fk', function() require('snacks').picker.keymaps() end, { desc = 'Find [K]eymaps'} )
kmap('snacks', 'n', '<leader>fa', function() require('snacks').picker.grep() end, { desc = 'Find in [A]ll workspace'} )
kmap('snacks', 'n', '<leader>fr', function() require('snacks').picker.resume() end, { desc = '[R]esume last Find'} )
kmap('snacks', 'n', '<leader>fc', function() require('snacks').picker.lazy() end, { desc = 'Find nvim [C]onfig'} )
kmap('snacks', 'n', '<leader>fb', function() require('snacks').picker.buffers({ layout = 'default' }) end, { desc = 'Find [B]uffers'} )
kmap('snacks', 'n', '<leader>fl', function() require('snacks').picker.lines({ layout = 'default' }) end, { desc = 'Find [L]ines'} )

-- [ search for noice ]
-- OPTION1: use telescope
kmap('noice',     'n', '<leader>fn', function() require('noice').cmd('telescope') end, { desc = '[n]otices'})

-- OPTION2: use snacks.picker
-- the below method currently has bug:https://github.com/folke/noice.nvim/issues/1075
-- kmap('snacks', 'n', '<leader>fn', function() require('snacks').picker.noice({ layout = 'dropdown' }) end, { desc = 'Find [N]otices'} )

-- OPTION3: use noice itself
-- kmap('noice', 'n', '<leader>fn', "<Cmd>NoiceHistory<CR>", { desc = 'Find [N]otices'} )

-- [ search for todo-comments ]
-- OPTION1: use telescope
-- kmap('todo-comments', 'n', '<leader>ft', '<Cmd>TodoTelescope<CR>', { desc = '[t]odo-comments'})

-- OPTION2: use snacks.picker
kmap('snacks', 'n', '<leader>ft', function() require('snacks').picker.todo_comments() end, { desc = 'Find [T]odo comments'} )

-- [ search for sessions ]
kmap('persisted', 'n', '<leader>fs', '<Cmd>Telescope persisted<CR>', { desc = '[F]ind session'})

-- [ toggle full screen ]
kmap('snacks', 'n', '<C-z>', function() require('snacks').zen() end, { desc = 'Toggle window fullscreen' })
kmap('snacks', 't', '<C-z>', function()
  vim.cmd('stopinsert') -- Exit terminal mode first
  vim.schedule(function()
    require('snacks').zen()
    -- Re-enter terminal mode after zen toggle
    vim.schedule(function()
      if vim.bo.buftype == 'terminal' then
        vim.cmd('startinsert')
      end
    end)
  end)
end, { desc = 'Toggle window fullscreen' })

-- NOTE: [[ Terminal <leader>t ]]
kmap('snacks', 'n', '<leader>tt', function() require('custom.terminal').create_term_cur() end, { desc = 'Create terminal (current dir)' })
kmap('snacks', 'n', '<leader>tT', function() require('custom.terminal').create_term_root() end, { desc = 'Create terminal (workspace root)' })
kmap('snacks', 'n', '<localleader>t', function() require('custom.terminal').toggle_opened_term() end, { desc = 'Toggle created [t]erminals' })
kmap('snacks', 'n', '<localleader>T', function() require('custom.terminal').toggle_float_term() end, { desc = 'Create floating [T]erminal' })

-- NOTE: [[ Git ]]

-- [ lazygit ]
kmap('snacks', 'n', '<localleader>g', function() require('snacks').lazygit.open() end, { desc = 'Toggle lazy[g]it' })

-- [ blame ]
-- OPTION1: use diffview
kmap('diffview', 'n', '<leader>gh', '<Cmd>DiffviewFileHistory %<CR>', { desc = 'Git: file [H]istory' })
-- OPTION2: use gitsigns
-- kmap('gitsigns', 'n', '<leader>gb', '<Cmd>Gitsigns blame<CR>', { desc = '[B]lame' })
kmap('gitsigns', 'n', '<leader>gb', '<Cmd>Gitsigns blame_line<CR>', { desc = 'Git: [B]lame line' })

-- [ diff ]
-- OPTION1: use diffview
kmap('diffview', 'n', '<leader>gd','<Cmd>DiffviewOpen<CR>', { desc = 'Git: [D]iff' }) -- open in conflicted files to solve conflict
-- OPTION2: use gitsigns
-- kmap('gitsigns', 'n', '<leader>gd', function() require('custom.git').toggle_diff() end, { desc = 'toggle [D]iff' })

-- quit diffview
kmap('diffview', 'n', '<leader>gc', '<Cmd>DiffviewClose<CR>', { desc = 'Git: [C]lose git tab' })

-- NOTE: [[ LSP ]]

-- diagnostic
-- kmap('lsp',     'n', '<leader>ll', vim.diagnostic.setloclist,               { desc = 'Lsp: quickfix [l]ist' })
kmap('trouble', 'n', '<leader>ll', '<Cmd>Trouble diagnostics<CR>',          { desc = 'Lsp: quickfix [l]ist' })
kmap('lspsaga', 'n', '<leader>ln', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { desc = 'Lsp: [n]ext diagnostic' })
kmap('lspsaga', 'n', '<leader>lp', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = 'Lsp: [p]rev diagnostic' })
-- display info
-- kmap('lspsaga', 'n', '<localleader>s', '<Cmd>Lspsaga outline<CR>', { desc = 'Toggle file [s]tructure' })
kmap('outline', 'n', '<localleader>s', '<Cmd>Outline<CR>', { desc = 'Toggle file [s]tructure' })
-- search and jump
kmap('lspsaga', 'n', '<leader>ld', '<Cmd>Lspsaga goto_definition<CR>', { desc = 'Lsp: [d]efinition' }) --  To jump back, press <C-t>.
kmap('lspsaga', 'n', '<leader>lv', '<Cmd>Lspsaga peek_definition<CR>', { desc = 'Lsp: [v]iew definition' })
kmap('lspsaga', 'n', '<leader>lf', '<Cmd>Lspsaga finder<CR>',          { desc = 'Lsp: [f]ind references' })
-- code actions
kmap('lspsaga', 'n', '<leader>lr', '<Cmd>Lspsaga rename<CR>',      { desc = 'Lsp: [r]eame' })
kmap('lspsaga', 'n', '<leader>la', '<Cmd>Lspsaga code_action<CR>', { desc = 'Lsp: code [a]ction' })

-- NOTE: [[ Debug <leader>d ]]
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


-- NOTE: [[ Code ]]
kmap('native', 'n', '<leader>cc', 'gcc', { desc = 'Toggle [C]omment', remap = true })
kmap('native', 'v', '<leader>cc', 'gc', { desc = 'Toggle [C]omment', remap = true })
kmap('conform', 'n', '<leader>cf', function()
  local buf = vim.api.nvim_get_current_buf()
  local disabled = vim.b[buf].disable_autoformat or vim.g.disable_autoformat
  if disabled then
    vim.cmd('FormatEnable')
  else
    vim.cmd('FormatDisable')
  end
end, { desc = 'Toggle [f]ormat' })
-- folding
kmap('native', 'n', '<localleader>o', 'zo', { desc = '[O]pen fold' })
kmap('native', 'n', '<localleader>f', 'zc', { desc = '[F]old fold' })
-- kmap('native', 'n', '<localleader>O', 'zO', { desc = '[O]pen top fold' })
-- kmap('native', 'n', '<localleader>F', 'zC', { desc = '[F]old top fold' })

-- NOTE: [[ Session ]]

-- kmap('persistence', 'n', '<leader>sl', function() require('persistence').load({ last = true }) end, { desc = '[L]ast session'})
-- kmap('persistence', 'n', '<leader>sf', function() require('persistence').select() end, { desc = '[F]ind session'})
-- kmap('persistence', 'n', '<leader>sd', function() require('persistence').load() end, { desc = 'session in current [D]ir'})
-- kmap('persistence', 'n', '<leader>ss', function() require('persistence').stop() end, { desc = '[S]top saving session'})

kmap('persisted', 'n', '<leader>sl', '<Cmd>SessionLoadLast<CR>', { desc = '[L]ast session'})
kmap('persisted', 'n', '<leader>sd', '<Cmd>SessionLoad<CR>', { desc = 'session in current [D]ir'})
kmap('persisted', 'n', '<leader>ss', '<Cmd>SessionStart<CR>', { desc = '[S]tart saving session'})
kmap('persisted', 'n', '<leader>sq', '<Cmd>SessionDelete<CR>', { desc = 'delete current session'})

-- NOTE: [[ AI ]]

-- OPTION1: use codecompanion
-- kmap('codecompanion', { 'n', 'v' }, '<localleader>a', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'Toggle a[i]' })
-- kmap('codecompanion', { 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionActions<cr>', { desc = 'AI: [a]ctions' })
-- kmap('codecompanion', 'v', '<leader>as', '<cmd>CodeCompanionChat Add<cr>', { desc = 'AI: [s]elect' })

-- OPTION2: use avante
-- kmap('avante', { 'n', 'v' }, '<localleader>a', '<cmd>AvanteToggle<cr>', { desc = 'Toggle [A]I' })

-- OPTION3: use gemini-cli
-- kmap('native', 'n', '<localleader>a', function() require('snacks').terminal.toggle('source ~/.nvm/nvm.sh && gemini', { cwd = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd(), start_insert = true, auto_insert = false, auto_close = true, }) end, { desc = 'Run gemini in root terminal' })

-- OPTION4: use claude code
kmap('snacks', 'n', '<localleader>a', function() require('custom.claude').toggle_claude() end, { desc = 'Toggle Claude' })
kmap('snacks', 'n', '<leader>ar', function() require('custom.claude').open_claude_resume() end, { desc = 'Open Claude resume' })
kmap('snacks', 'n', '<leader>ac', function() require('custom.claude').open_claude_continue() end, { desc = 'Open Claude continue' })
kmap('snacks', 'n', '<leader>as', function() require('custom.claude').switch_provider() end, { desc = 'Switch Claude provider' })


-- NOTE: [[ Plugins ]]
kmap('lazy', 'n', '<leader>pp', '<cmd>Lazy<CR>', { desc = 'view [p]lugins' })
kmap('lsp', 'n', '<leader>pl', '<cmd>checkhealth vim.lsp<CR>', { desc = 'check [l]sp' })
kmap('mason', 'n', '<leader>pm', '<cmd>Mason<CR>', { desc = 'open [m]ason' })
kmap('conform', 'n', '<leader>pc', '<cmd>ConformInfo<CR>', { desc = 'check [c]onform' })

-- NOTE: [[ Miscellaneous ]]
--
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
kmap('native', 'n', '<Esc>', '<cmd>nohlsearch<CR>')
-- use <C-s> to save file
kmap('native', 'n', '<C-s>', ':w<CR>', { desc = '[f]ile [s]ave' })

-- stylua: ignore end

return M
