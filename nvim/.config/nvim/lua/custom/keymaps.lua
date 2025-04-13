--  NOTE: See `:help vim.keymap.set()`

-- set a function to configure keymaps
local function kmap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function setup_keymaps()
  -- NOTE:
  --------------  native vim optimization  ---------------

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  kmap('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Improved native jumping using hop.nvim
  local hop = require 'hop'
  kmap({ 'n', 'v' }, 'f', function()
    hop.hint_char1 {
      direction = require('hop.hint').HintDirection.AFTER_CURSOR,
      current_line_only = false,
    }
  end, { desc = 'hop forward', remap = true })
  kmap({ 'n', 'v' }, 'F', function()
    hop.hint_char1 {
      direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
      current_line_only = false,
    }
  end, { desc = 'hop backward', remap = true })
  kmap('n', 's', function()
    hop.hint_char1()
  end, { desc = 'Hop to character' })
  kmap('n', 'S', function()
    hop.hint_words()
  end, { desc = 'Hop to word' })

  -- NOTE:
  ------------------  file operation (<leader>f)  -----------------
  kmap('n', '<leader>fs', ':w<CR>', { desc = '[f]ile [s]ave' })
  kmap('n', '<C-s>', ':w<CR>', { desc = '[f]ile [s]ave' })
  kmap('n', '<leader>fS', ':saveas ', { desc = '[f]ile [S]aveas' })

  -- NOTE:
  ------- buffer operation (C to navigate, <leader>b to operate)------------

  -- plugin: bufferline
  kmap('n', '<C-[>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev Buffer' })
  kmap('n', '<C-]>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })
  kmap('n', '<leader>bh', '<cmd>BufferLineMovePrev<cr>', { desc = 'Move buffer prev' })
  kmap('n', '<leader>bl', '<cmd>BufferLineMoveNext<cr>', { desc = 'Move buffer next' })
  kmap('n', '<leader>bd', ':bdelete<CR>', { desc = '[D]elete buffer' })

  -- NOTE:
  --------  window operation (C to navigate) --------

  --  See `:help wincmd` for a list of all window commands
  kmap('n', '<C-->', ':split<CR>', { desc = 'split horizontal' })
  kmap('n', '<C-\\>', ':vsplit<CR>', { desc = 'split vertical' })
  kmap('n', '<C-h>', '<C-w>h', { desc = 'change to left window' })
  kmap('n', '<C-j>', '<C-w>j', { desc = 'change to lower window' })
  kmap('n', '<C-k>', '<C-w>k', { desc = 'change to upper window' })
  kmap('n', '<C-l>', '<C-w>l', { desc = 'change to right window' })
  kmap('n', '<C-q>', '<C-w>q', { desc = 'delete window' })
  local zoomed_win = nil
  local original_dims = {}
  local blacklist = { 'neo-tree' } -- Add filetypes to ignore
  kmap({ 'n', 't' }, '<C-z>', function()
    if zoomed_win then
      -- Restore original dimensions and clear tracking
      vim.api.nvim_win_set_height(zoomed_win, original_dims.height)
      vim.api.nvim_win_set_width(zoomed_win, original_dims.width)
      zoomed_win = nil
    else
      -- Check if current buffer is in blacklist
      local ft = vim.bo.filetype
      if vim.tbl_contains(blacklist, ft) then
        return
      end
      -- Store dimensions and maximize
      local win = vim.api.nvim_get_current_win()
      original_dims = {
        height = vim.api.nvim_win_get_height(win),
        width = vim.api.nvim_win_get_width(win),
      }
      zoomed_win = win
      -- Maximize window
      vim.cmd [[wincmd _ | wincmd |]]
      -- Clean up if window closes
      vim.api.nvim_create_autocmd('WinClosed', {
        once = true,
        pattern = tostring(win),
        callback = function()
          zoomed_win = nil
        end,
      })
    end
  end, { desc = 'Toggle window zoom' })

  -- NOTE:
  -------- code (<leader>c) --------
  kmap('n', '<leader>cc', 'gcc', { desc = '[c]ode toggle [c]omment', remap = true })
  kmap('v', '<leader>cc', 'gc', { desc = '[c]ode toggle [c]omment', remap = true })
  kmap('n', '<leader>cf', 'zc', { desc = '[c]ode [f]old', remap = true })
  -- auto format
  kmap('n', '<leader>cf', function()
    require('conform').format { async = true, lsp_format = 'fallback' }
  end, { desc = '[c]ode [f]ormat buffer' })

  -- NOTE:
  -------- terminal (<leader>t) --------
  kmap( -- Current file directory terminal
    'n',
    '<leader>tt',
    function()
      Snacks.terminal.toggle(nil, {
        cwd = vim.fn.expand '%:p:h',
        start_insert = false,
        auto_insert = false,
        auto_close = true,
      })
    end,
    { desc = 'Toggle terminal (current dir)' }
  )
  kmap( -- Workspace root terminal
    'n',
    '<leader>tT',
    function()
      Snacks.terminal.toggle(nil, {
        cwd = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd(),
        start_insert = false,
        auto_insert = false,
        auto_close = true,
      })
    end,
    { desc = 'Toggle terminal (workspace root)' }
  )

  -- NOTE:
  -------- search and goto (<leader>s, <leader>g) --------

  -- plugin telescope
  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  kmap('n', '<leader>gf', builtin.find_files, { desc = '[g]oto [f]iles' })
  kmap('n', '<leader>g.', builtin.oldfiles, { desc = '[g]oto Recent Files ("." for repeat)' })
  kmap('n', '<leader>gb', builtin.buffers, { desc = '[g]oto existing [b]uffers' })
  -- kmap('n', '<leader>ss', builtin.builtin, { desc = '[s]earch [s]elect Telescope' })
  kmap('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
  kmap('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
  kmap('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
  kmap('n', '<leader>sa', builtin.live_grep, { desc = '[s]earch [a]ll workspace by grep' })
  kmap('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
  -- kmap('n', '<leader>sr', builtin.resume, { desc = '[s]earch [r]esume' })
  vim.keymap.set('n', '<leader>sb', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[s]earch in current [b]uffer fuzzily' })
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>so', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[s]earch in [o]pen Files by grep' })
  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>gn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[g]oto [n]eovim files' })

  -- NOTE:
  --------  lsp (<leader>l) --------
  ---
  -- more keymaps see plugin mason-lspconfig
  -- Diagnostic keymaps
  kmap('n', '<leader>ll', vim.diagnostic.setloclist, { desc = 'Open [l]sp diagnostic quickfix [l]ist' })

  -- NOTE:
  --------  nvim-dap (<leader>d) --------
  local dap, dapui = require 'dap', require 'dapui'
  kmap('n', '<leader>ds', dap.continue, { desc = ' Start/Continue' })
  kmap('n', '<F1>', dap.continue, { desc = ' Start/Continue' })
  kmap('n', '<leader>di', dap.step_into, { desc = ' Step into' })
  kmap('n', '<F2>', dap.step_into, { desc = ' Step into' })
  kmap('n', '<leader>do', dap.step_over, { desc = ' Step over' })
  kmap('n', '<F3>', dap.step_over, { desc = ' Step over' })
  kmap('n', '<leader>dO', dap.step_out, { desc = ' Step out' })
  kmap('n', '<F4>', dap.step_out, { desc = ' Step out' })
  kmap('n', '<leader>dq', dap.close, { desc = 'DAP: Close session' })
  kmap('n', '<leader>dQ', dap.terminate, { desc = ' Terminate session' })
  kmap('n', '<leader>dr', dap.restart_frame, { desc = 'DAP: Restart' })
  kmap('n', '<F5>', dap.restart_frame, { desc = 'DAP: Restart' })
  kmap('n', '<leader>dc', dap.run_to_cursor, { desc = 'DAP: Run to Cursor' })
  kmap('n', '<leader>dR', dap.repl.toggle, { desc = 'DAP: Toggle REPL' })
  kmap('n', '<leader>dh', require('dap.ui.widgets').hover, { desc = 'DAP: Hover' })
  kmap('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Breakpoint' })
  kmap('n', '<leader>dB', function()
    local input = vim.fn.input 'Condition for breakpoint:'
    dap.set_breakpoint(input)
  end, { desc = 'DAP: Conditional Breakpoint' })
  kmap('n', '<leader>dD', dap.clear_breakpoints, { desc = 'DAP: Clear Breakpoints' })

  -- NOTE:
  --------  codecompanion (<leader>i) --------
  kmap({ 'n', 'v' }, '<leader>ia', '<cmd>CodeCompanionActions<cr>', { desc = 'a[i] [a]ctions' })
  kmap('v', '<leader>is', '<cmd>CodeCompanionChat Add<cr>', { desc = 'a[i] [s]elect' })
  kmap('n', '<leader>ii', ':CodeCompanion ', { desc = 'a[i] [i]nline' })

  -- NOTE:
  -------- plugins (<leader>p) --------
  kmap('n', '<leader>pl', '<cmd>Lazy<CR>', { desc = 'open [l]azy.nvim' })
  kmap('n', '<leader>pm', '<cmd>Mason<CR>', { desc = 'open [M]ason' })

  -- NOTE:
  -------- toggle (;) --------

  -- toggle neo-tree
  kmap('n', ';e', ':Neotree toggle<CR>', { desc = 'NeoTree toggle' })
  kmap('n', ';f', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' })
  -- toggle terminal: this requires plugin 'snacks.terminal' to work
  kmap('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  kmap( -- Toggle all terminals
    'n',
    ';t',
    function()
      local terms = Snacks.terminal.list()
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
  -- toggle dapui
  kmap('n', ';d', require('dapui').toggle, { desc = 'Toggle DAP UI' })
  -- toggle codecompanion: this requires plugin 'codecompanion' to work
  kmap({ 'n', 'v' }, ';i', '<cmd>CodeCompanionChat Toggle<cr>', { desc = '[t]oggle a[i]' })
end

return {
  setup = function()
    --setup keymaps
    setup_keymaps()
  end,
}
