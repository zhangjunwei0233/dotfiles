-- [[ Claude Code management using snacks_terminal ]]
local M = {}

-- Table to track claude terminals
local claude_terminals = {}

-- Claude command configurations for easy switching
local claude_commands = {
  gac = 'cp ~/.claude/settings.json.gaccode ~/.claude/settings.json 2>/dev/null; ~/APPS/claudecode/gaccode/bin/claude',
  flap = 'cp ~/.claude/settings.json.flap ~/.claude/settings.json 2>/dev/null; ~/APPS/claudecode/flap/bin/claude',
}

-- Current claude provider (change this to switch providers)
local current_provider = 'flap'

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
      local term = require('snacks').terminal.toggle(claude_commands[current_provider], claude_config)
      if term then
        term.cmd = claude_commands[current_provider]
        table.insert(claude_terminals, term)
      end
    end
  end
end

-- Open claude with resume flag (not toggle)
M.open_claude_resume = function()
  local term = require('snacks').terminal.toggle(claude_commands[current_provider] .. ' --resume', claude_config)
  if term then
    term.cmd = claude_commands[current_provider] .. ' --resume'
    table.insert(claude_terminals, term)
  end
end

-- Open claude with continue flag (not toggle)
M.open_claude_continue = function()
  local term = require('snacks').terminal.toggle(claude_commands[current_provider] .. ' --continue', claude_config)
  if term then
    term.cmd = claude_commands[current_provider] .. ' --continue'
    table.insert(claude_terminals, term)
  end
end

-- Switch claude provider
M.switch_provider = function()
  local providers = vim.tbl_keys(claude_commands)
  local current_index = 1

  for i, provider in ipairs(providers) do
    if provider == current_provider then
      current_index = i
      break
    end
  end

  local next_index = (current_index % #providers) + 1
  current_provider = providers[next_index]

  vim.notify('Switched to Claude provider: ' .. current_provider, vim.log.levels.INFO)
end

-- Get current provider
M.get_current_provider = function()
  return current_provider
end

return M
