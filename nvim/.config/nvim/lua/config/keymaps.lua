-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Window layout and navigation.
map({ "n", "t" }, "<localleader>-", "<cmd>split<cr>", { desc = "Split Horizontal" })
map({ "n", "t" }, "<localleader>\\", "<cmd>vsplit<cr>", { desc = "Split Vertical" })
map({ "n", "t" }, "<localleader>q", "<cmd>wincmd q<cr>", { desc = "Close Window" })
map({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

map("n", "<C-n>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Buffer" })
map("n", "<C-p>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bh", "<cmd>BufferLineMovePrev<cr>", { desc = "Move Buffer Left" })
map("n", "<leader>bl", "<cmd>BufferLineMoveNext<cr>", { desc = "Move Buffer Right" })
map("n", "<localleader><S-q>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

map("n", "<localleader>e", function()
  Snacks.explorer()
end, { desc = "Explorer" })
map("n", "<localleader>s", function()
  Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter })
end, { desc = "LSP Symbols" })
map("n", "<localleader>g", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "Lazygit" })

local function current_file_dir()
  local file = vim.api.nvim_buf_get_name(0)
  return file ~= "" and vim.bo.buftype == "" and vim.fs.dirname(file) or vim.fn.getcwd()
end

local split_terminals = {}

map("n", "<leader>t", function()
  local terminal = Snacks.terminal.open(nil, {
    cwd = current_file_dir(),
    win = {
      position = "bottom",
      wo = { winbar = "" },
    },
  })
  split_terminals[#split_terminals + 1] = terminal
end, { desc = "Terminal (Current File Dir)" })

map({ "n", "t" }, "<localleader>t", function()
  split_terminals = vim.tbl_filter(function(terminal)
    return terminal:buf_valid()
  end, split_terminals)

  if #split_terminals == 0 then
    return
  end

  local hide = vim.iter(split_terminals):any(function(terminal)
    return terminal:win_valid()
  end)

  for _, terminal in ipairs(split_terminals) do
    if hide then
      terminal:hide()
    else
      terminal:show()
    end
  end
end, { desc = "Toggle Created Terminals" })

map({ "n", "t" }, "<localleader>m", function()
  if vim.fn.mode() ~= "t" then
    Snacks.zen.zoom()
    return
  end

  vim.cmd.stopinsert()
  vim.schedule(function()
    Snacks.zen.zoom()
    vim.schedule(function()
      if vim.bo.buftype == "terminal" then
        vim.cmd.startinsert()
      end
    end)
  end)
end, { desc = "Toggle Window Zoom" })

-- Personal picker namespace.
map("n", "<leader>fp", function()
  Snacks.picker()
end, { desc = "Pickers" })
map("n", "<leader>ff", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })
map("n", "<leader>f.", function()
  Snacks.picker.recent()
end, { desc = "Recent Files" })
map("n", "<leader>fw", function()
  Snacks.picker.grep_word()
end, { desc = "Word or Selection" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help Pages" })
map("n", "<leader>fk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>fa", function()
  Snacks.picker.grep()
end, { desc = "Grep Workspace" })
map("n", "<leader>fr", function()
  Snacks.picker.resume()
end, { desc = "Resume Picker" })
map("n", "<leader>fc", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Config Files" })
map("n", "<leader>fb", function()
  Snacks.picker.buffers({ layout = "default" })
end, { desc = "Buffers" })
map("n", "<leader>fl", function()
  Snacks.picker.lines({ layout = "default" })
end, { desc = "Buffer Lines" })
map("n", "<leader>ft", "<leader>st", { remap = true, desc = "Todo Comments" })
map("n", "<leader>fn", "<leader>snh", { remap = true, desc = "Notification History" })

-- Session aliases over LazyVim's persistence.nvim integration.
map("n", "<leader>sl", "<leader>ql", { remap = true, desc = "Restore Last Session" })
map("n", "<leader>sd", "<leader>qs", { remap = true, desc = "Restore Directory Session" })
map("n", "<leader>sf", "<leader>qS", { remap = true, desc = "Select Session" })
map("n", "<leader>ss", "<leader>qd", { remap = true, desc = "Stop Session Saving" })

-- LSP aliases retain the old <leader>l muscle memory.
map("n", "<leader>ll", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
map("n", "<leader>ln", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next Diagnostic" })
map("n", "<leader>lp", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous Diagnostic" })
map("n", "<leader>ld", function()
  Snacks.picker.lsp_definitions()
end, { desc = "Definitions" })
map("n", "<leader>lv", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "<leader>lf", function()
  Snacks.picker.lsp_references()
end, { desc = "References" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })

map("n", "<leader>cc", "gcc", { remap = true, desc = "Toggle Comment" })
map("x", "<leader>cc", "gc", { remap = true, desc = "Toggle Comment" })
map("n", "<localleader>o", "zo", { desc = "Open Fold" })
map("n", "<localleader>f", "zc", { desc = "Close Fold" })

map("n", "<leader>pp", "<cmd>Lazy<cr>", { desc = "Plugin Manager" })
map("n", "<leader>pl", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP Health" })
map("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>pc", "<cmd>ConformInfo<cr>", { desc = "Formatter Info" })
