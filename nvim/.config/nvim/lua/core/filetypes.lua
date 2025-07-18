local M = {}

M.setup = function()
  -- [[ verilog filetype config ]]
  local group_verilog_ft = vim.api.nvim_create_augroup('verilog_ft', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    -- change *.v files to filetype 'verilog' and set tab settings
    desc = 'auto set v filetype to verilog and configure tab settings',
    pattern = { '*.v', 'verilog' },
    group = group_verilog_ft,
    callback = function()
      vim.bo.filetype = 'verilog'
      vim.bo.tabstop = 8
      vim.bo.shiftwidth = 0
      vim.bo.expandtab = true
    end,
  })

  -- [[ python filetype config ]]
  local group_python_ft = vim.api.nvim_create_augroup('python_ft', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'auto config for python filetype',
    pattern = 'python',
    group = group_python_ft,
    callback = function()
      vim.bo.tabstop = 4
      vim.bo.shiftwidth = 0
    end,
  })
end

return M
