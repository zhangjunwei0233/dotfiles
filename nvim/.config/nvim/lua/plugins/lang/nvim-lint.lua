-- [[ Code linter ]]
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')

    -- configure linters by filetype
    lint.linters_by_ft = {
      python = { 'ruff' },
    }

    -- auto-lint on save and text change
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- load keymaps
    local keymaps = require('core.keymaps')['nvim-lint']
    if keymaps then
      keymaps()
    else
      vim.notify('nvim-lint loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}

