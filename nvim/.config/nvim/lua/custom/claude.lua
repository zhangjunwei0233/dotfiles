-- [[ Claude Code management using snacks_terminal ]]
local M = {}

-- Table to track claude terminals
local claude_terminals = {}

-- Base configuration for claude terminals
local claude_config = {
  cwd = vim.fn.getcwd(),
  win = { position = 'right', width = 0.5 },
  start_insert = false,
  auto_insert = false,
  auto_close = false,
}

-- Helper function to find existing claude terminal by command
local function find_claude_terminal(command)
  for _, term in ipairs(claude_terminals) do
    if term.cmd == command and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
      return term
    end
  end
  return nil
end

-- Helper function to clean up invalid terminals
local function cleanup_terminals()
  local valid_terminals = {}
  for _, term in ipairs(claude_terminals) do
    if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
      table.insert(valid_terminals, term)
    end
  end
  claude_terminals = valid_terminals
end

-- Helper function to toggle claude terminal
local function toggle_claude_terminal(command)
  cleanup_terminals()

  local existing_term = find_claude_terminal(command)

  if existing_term then
    -- If terminal exists, toggle it
    if existing_term.win and vim.api.nvim_win_is_valid(existing_term.win) then
      existing_term:hide()
    else
      existing_term:show()
    end
  else
    -- Create new terminal
    local term = require('snacks').terminal.toggle(command, claude_config)
    if term then
      term.cmd = command -- Store command for identification
      table.insert(claude_terminals, term)
    end
  end
end

-- Toggle any existing claude terminal, or create basic one if none exists
M.toggle_claude = function()
  cleanup_terminals()

  -- Check if any claude terminal is visible
  local any_visible = false
  for _, term in ipairs(claude_terminals) do
    if term.win and vim.api.nvim_win_is_valid(term.win) then
      any_visible = true
      break
    end
  end

  if any_visible then
    -- Hide all claude terminals
    for _, term in ipairs(claude_terminals) do
      if term.win and vim.api.nvim_win_is_valid(term.win) then
        term:hide()
      end
    end
  else
    -- Show first available terminal or create new basic one
    local first_term = claude_terminals[1]
    if first_term then
      first_term:show()
    else
      -- Create new basic claude terminal
      local term = require('snacks').terminal.toggle('source ~/.nvm/nvm.sh && claude', claude_config)
      if term then
        term.cmd = 'source ~/.nvm/nvm.sh && claude'
        table.insert(claude_terminals, term)
      end
    end
  end
end

-- Open claude with resume flag (not toggle)
M.open_claude_resume = function()
  local term = require('snacks').terminal.toggle('source ~/.nvm/nvm.sh && claude --resume', claude_config)
  if term then
    term.cmd = 'source ~/.nvm/nvm.sh && claude --resume'
    table.insert(claude_terminals, term)
  end
end

-- Open claude with continue flag (not toggle)
M.open_claude_continue = function()
  local term = require('snacks').terminal.toggle('source ~/.nvm/nvm.sh && claude --continue', claude_config)
  if term then
    term.cmd = 'source ~/.nvm/nvm.sh && claude --continue'
    table.insert(claude_terminals, term)
  end
end

return M
