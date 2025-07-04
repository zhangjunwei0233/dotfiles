-- [[ Terminal management using snacks_terminal ]]
local M = {}

-- Table to track non-floating terminals
local non_floating_terminals = {}

M.create_term_cur = function()
  local term = require('snacks').terminal.toggle(nil, {
    cwd = vim.fn.expand('%:p:h'),
    start_insert = false,
    auto_insert = false,
    auto_close = true,
  })
  -- Add to tracking table if it's a new terminal
  if term then
    table.insert(non_floating_terminals, term)
  end
end

M.create_term_root = function()
  local term = require('snacks').terminal.toggle(nil, {
    cwd = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd(),
    start_insert = false,
    auto_insert = false,
    auto_close = true,
  })
  -- Add to tracking table if it's a new terminal
  if term then
    table.insert(non_floating_terminals, term)
  end
end

M.toggle_opened_term = function()
  -- Clean up invalid terminals from our tracking table
  local valid_terminals = {}
  for _, term in ipairs(non_floating_terminals) do
    if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
      table.insert(valid_terminals, term)
    end
  end
  non_floating_terminals = valid_terminals

  -- Check if any non-floating terminals are visible
  local any_visible = false
  for _, term in ipairs(non_floating_terminals) do
    if term.win and vim.api.nvim_win_is_valid(term.win) then
      any_visible = true
      break
    end
  end

  -- Toggle only our tracked non-floating terminals
  for _, term in ipairs(non_floating_terminals) do
    if any_visible then
      term:hide()
    else
      term:show()
    end
  end
end

M.toggle_float_term = function()
  require('snacks').terminal.toggle(vim.o.shell, {
    win = {
      relative = 'editor',
      style = 'terminal', -- Use terminal style from config
    },
  })
end

return M
