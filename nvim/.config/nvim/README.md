This is a setup for nvim v0.11+, since the way nvim handles lsp configuration
has gone through a breaking change in v0.11, the setup wouldn't work for older
versions

## quick startup

first backup the original config:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.locals/share/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

then clone this setup to `~/.config`, or use GNU stow:

```bash
cd dotfiles
stow nvim
```

Note that the executable of Lsp, formatters and debugers have to be manually installed.
You can do this through mason (a Lsp package manager), type `<Space>pm` in normal mode to open it

## config structure

**basic setups** are stored under `/lua/core` folder, which includes:

- vim options and global variables (in basic.lua)
- all the custom keymaps (in keymaps.lua)
- all the custom autocmds (in autocmds.lua)

Advanced functionalities could be reached through either **advanced setup** or **plugins**

- native setup is stored under `/lua/custom` folder
- plugins is stored under `/lua/plugins` folder, which contains:
    - lang: language relevant setup, such as formatter, lsp functions, ...
    - themes: color themes
    - ui: all plugins that improves visiual display
    - utils: all plugins that improves operation, like integrations with other tools or optimization of native operations

On startup, nvim loads `init.lua`, in which it loads **basic setup**, **advanced setup** and **plugins**

Keymaps and autocmds are not to be loaded uniformly, they are seperated to several modules and can be loaded
in the corresponding place respectively, do this via `require(core.keymaps).${MODULE_NAME}()`.

for example, native module is loaded in `init.lua` while plugin modules are loaded in their `config` function

## Keymap design

`<leader>` is set to `<Space>`, `<localleader>` is set to `;`

1. all the usr configure functions and utils: "<leader>..."

2. window and buffer navigation: "<C-...>"
    - move-window: <C-hjkl>
    - move-buffer: <C-np>
    - zoom-in window: <C-z>

3. change window layout(such as term toggle): "<localleader>..."
    - split: "<localleader>-" and "<localleader>\"
    - delete_window: "<localleader>q"
    - delete-buffer: "<localleader><S-q>"
    - toggle_in_split: "<localleader><lowerCaseLetter>"
    - toggle_in_float: "<localleader><UpperCaseLetter>"

more speicific keymaps could been seen via plugin `which-key`, just type <leader> or <localleader> and wait

## Extend the config

to install a new lsp:

1. add lsp config file in ${CONFIG_HOME}/lsp (this is front end)
2. enable it in ${CONFIG_HOME}/lua/custom/lsp.lua
3. download it through mason (this is back end)

to install a formatter:

1. add formatter config in ${CONFIG_HOME}/lua/plugins/lang/conform.lua (this is front end)
2. download it through mason (this is back end)

to add a new plugin:

1. create a .lua config file under ${CONFIG_HOME}/lua/plugins
2. add keymaps in ${CONFIG_HOME}/lua/core/keymaps and require it in the config file
