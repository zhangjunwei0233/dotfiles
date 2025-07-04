-- [[ A Debugger ]]
return {
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    config = function()
      local dap = require('dap')

      -- [[ configure adapters ]]
      -- copied from nvim-dap -> Debug Adapter Installation
      -- [cpptools]: for cpp, c, rust
      dap.adapters.cppdbg = { -- using vscode-cpptools
        id = 'cppdbg',
        type = 'executable',
        command = 'OpenDebugAD7', -- or if not in $PATH: "/absolute/path/to/OpenDebugAD7"
        options = { detached = false },
      }
      -- [debugpy]: for python. configured using extra plugin at the bottom of this file

      -- filetype configurations
      dap.configurations.cpp = {
        {
          name = 'Launch file (OpenDebugAD7 from cpptools)',
          type = 'cppdbg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = true,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
        {
          name = 'Attach to local gdbserver :1234',
          type = 'cppdbg',
          request = 'launch',
          MIMode = 'gdb',
          miDebuggerServerAddress = 'localhost:1234',
          miDebuggerPath = '/usr/bin/gdb',
          cwd = '${workspaceFolder}',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'theHamsta/nvim-dap-virtual-text', 'nvim-neotest/nvim-nio' },
    config = function()
      -- setup virtual text
      require('nvim-dap-virtual-text').setup() -- optional

      -- UI responsiveness
      local dap, dapui = require('dap'), require('dapui')
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- customize UI layout
      dapui.setup({
        layouts = {
          {
            position = 'left',
            size = 0.4,
            elements = {
              { id = 'stacks', size = 0.2 },
              { id = 'scopes', size = 0.5 },
              { id = 'breakpoints', size = 0.15 },
              { id = 'watches', size = 0.15 },
            },
          },
          {
            position = 'bottom',
            size = 0.2,
            elements = {
              { id = 'repl', size = 0.4 },
              { id = 'console', size = 0.6 },
            },
          },
        },
      })

      -- Custom breakpoint icons
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'Number', linehl = '', numhl = 'Number' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'Number', linehl = '', numhl = 'Number' })
      vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'String', linehl = '', numhl = 'String' })

      -- setup keymaps
      local keymaps = require('core.keymaps')['nvim-dap']
      if keymaps then
        keymaps()
      else
        vim.notify('nvim-dap loaded without keymap\n', vim.log.levels.WARN)
      end
    end,
  },
  { -- python debugger could be specifically configured using this plugin
    'mfussenegger/nvim-dap-python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    ft = { 'python' },
    config = function()
      local path = vim.fn.expand('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
      if vim.fn.executable(path) == 1 then
        require('dap-python').setup(path)
      else
        vim.notify('debugpy not found at ' .. path .. ', please install via Mason', vim.log.levels.WARN)
      end
    end,
  },
}
