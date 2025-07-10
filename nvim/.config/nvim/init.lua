-- [[ Load core setup ]]
require('core.basic')
require('core.filetypes').setup()

-- [[ Load custom setups ]]
--
-- to install a new lsp:
-- 1. add lsp config file in ${CONFIG_HOME}/lsp (this is front end)
-- 2. enable it in ${CONFIG_HOME}/lua/custom/lsp.lua
-- 3. download it through mason (this is back end)
--
-- to install a formatter:
-- 1. add formatter config in ${CONFIG_HOME}/lua/plugins/lang/conform.lua (this is front end)
-- 2. download it through mason (this is back end)
require('custom.lsp')
require('custom.foldings')

-- [[ Load plugins ]]
-- to add a new plugin:
-- 1. create a .lua config file under ${CONFIG_HOME}/lua/plugins
-- 2. add keymaps in ${CONFIG_HOME}/lua/core/keymaps and require it in the config file
require('plugins.lazy')

-- [[ Load keymaps for native ]]
require('core.utils').setup_keymaps('native')

-- [[ load autocmds for native ]]
require('core.utils').load_plugin_autocmds('native')
