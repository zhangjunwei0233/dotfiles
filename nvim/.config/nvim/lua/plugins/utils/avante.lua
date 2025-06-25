return {
  'yetone/avante.nvim',
  enabled = true,
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make', -- ⚠️ must add this line! ! !
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = 'deepseek',
    providers = {
      deepseek = {
        __inherited_from = 'openai',
        api_key_name = 'DEEPSEEK_API_KEY',
        endpoint = 'https://api.deepseek.com',
        model = 'deepseek-coder',
      },
      -- claude is the default
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-3-5-sonnet-20241022',
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 4096,
        },
      },
    },
    selector = { provider = 'telescope' },
    input = {
      provider = 'snacks',
      provider_opts = { title = 'Avante Input', icon = '' },
    },
    web_search_engine = {
      provider = 'tavily', -- tavily, serpapi, searchapi, google, kagi, brave 或 searxng
      proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
    },
    hints = { enabled = true }, -- show hints like `<leader>aa to ask` in visual mode
    windows = {
      width = 50, -- 默认基于可用宽度的百分比
      input = {
        height = 16, -- 垂直布局中输入窗口的高度
      },
      edit = {
        start_insert = false, -- 打开编辑窗口时开始插入模式
      },
      ask = {
        floating = false, -- 在浮动窗口中打开 'AvanteAsk' 提示
        start_insert = false, -- 打开询问窗口时开始插入模式
      },
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
  config = function(_, opts)
    require('avante').setup(opts)

    -- load keymaps
    local keymaps = require('core.keymaps').avante
    if keymaps then
      keymaps()
    else
      vim.notify('avante loaded without keymap\n', vim.log.levels.WARN)
    end
  end,
}
