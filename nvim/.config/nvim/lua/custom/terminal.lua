-- [[ Termianl management using snacks_terminal ]]
local M = {}

M.create_term_cur = function()
  require('snacks').terminal.toggle(nil, {
    cwd = vim.fn.expand('%:p:h'),
    start_insert = false,
    auto_insert = false,
    auto_close = true,
  })
end

M.create_term_root = function()
  require('snacks').terminal.toggle(nil, {
    cwd = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd(),
    start_insert = false,
    auto_insert = false,
    auto_close = true,
  })
end

M.toggle_opened_term = function()
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
