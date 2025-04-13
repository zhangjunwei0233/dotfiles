return {
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    config = function()
      local dap = require 'dap'
      -- NOTE: configure adapters
      dap.adapters.cppdbg = { -- using vscode-cpptools
        id = 'cppdbg',
        type = 'executable',
        command = 'OpenDebugAD7', -- or if not in $PATH: "/absolute/path/to/OpenDebugAD7"
        options = { detached = false },
      }

      -- NOTE: filetype configurations
      dap.configurations.cpp = {
        {
          name = 'Launch file',
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
          name = 'Attach to gdbserver :1234',
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
      -- NOTE: setup virtual text
      require('nvim-dap-virtual-text').setup() -- optional

      -- NOTE: UI responsiveness
      local dap, dapui = require 'dap', require 'dapui'
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

      -- NOTE: customize UI layout
      dapui.setup {
        layouts = {
          {
            position = 'left',
            size = 0.3,
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
              { id = 'repl', size = 0.3 },
              { id = 'console', size = 0.7 },
            },
          },
        },
      }

      -- NOTE: Custom breakpoint icons
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
      vim.fn.sign_define(
        'DapBreakpointCondition',
        { text = '', texthl = 'DapBreakpointCondition', linehl = 'DapBreakpointCondition', numhl = 'DapBreakpointCondition' }
      )
      vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

      -- NOTE: keymaps
      vim.keymap.set('n', '<leader>td', dapui.toggle, { desc = 'Toggle DAP UI' })
      vim.keymap.set('n', '<leader>ds', dap.continue, { desc = ' Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.continue, { desc = ' Start/Continue' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = ' Step into' })
      vim.keymap.set('n', '<F2>', dap.step_into, { desc = ' Step into' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = ' Step over' })
      vim.keymap.set('n', '<F3>', dap.step_over, { desc = ' Step over' })
      vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = ' Step out' })
      vim.keymap.set('n', '<F4>', dap.step_out, { desc = ' Step out' })
      vim.keymap.set('n', '<leader>dq', dap.close, { desc = 'DAP: Close session' })
      vim.keymap.set('n', '<leader>dQ', dap.terminate, { desc = ' Terminate session' })
      vim.keymap.set('n', '<leader>dr', dap.restart_frame, { desc = 'DAP: Restart' })
      vim.keymap.set('n', '<F5>', dap.restart_frame, { desc = 'DAP: Restart' })

      vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'DAP: Run to Cursor' })
      vim.keymap.set('n', '<leader>dR', dap.repl.toggle, { desc = 'DAP: Toggle REPL' })
      vim.keymap.set('n', '<leader>dh', require('dap.ui.widgets').hover, { desc = 'DAP: Hover' })

      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Breakpoint' })
      vim.keymap.set('n', '<leader>dB', function()
        local input = vim.fn.input 'Condition for breakpoint:'
        dap.set_breakpoint(input)
      end, { desc = 'DAP: Conditional Breakpoint' })
      vim.keymap.set('n', '<leader>dD', dap.clear_breakpoints, { desc = 'DAP: Clear Breakpoints' })
    end,
  },
}
