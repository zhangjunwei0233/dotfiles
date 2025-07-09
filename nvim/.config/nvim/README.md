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

- **init.lua**: Entry point that loads basic setup, custom functionality, and plugins
- **lua/core/**: Contains fundamental Neovim configuration
  - `basic.lua`: Vim options, global variables, and basic settings
  - `keymaps.lua`: Keymap definitions organized by plugin/functionality
  - `autocmds.lua`: Auto-commands for different contexts
- **lua/custom/**: Native Lua implementations of advanced features (folding, zoom-window, ...)
- **lua/plugins/**: Plugin configurations organized by category
  - `lang/`: Language-specific tools (LSP, formatting, debugging)
  - `themes/`: Color schemes and theming
  - `ui/`: User interface enhancements
  - `utils/`: Utility plugins and integrations
  - `disabled/`: Temporarily disabled plugin configurations

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

3. window layout changes and toggles: "<localleader>..."
    - split: "<localleader>-" and "<localleader>\\"
    - delete_window: "<localleader>q"
    - delete-buffer: "<localleader><S-q>"
    - toggle_in_split: "<localleader><lowerCaseLetter>"
    - toggle_in_float: "<localleader><UpperCaseLetter>"

more speicific keymaps could been seen via plugin `which-key`, just type <leader> or <localleader> and wait

## Extend the config

### Adding New LSP Servers
1. Create configuration file in `/lsp/` directory (e.g., `myserver.lua`)
2. Enable the server in `lua/custom/lsp.lua` using `vim.lsp.enable('myserver')`
3. Install the server binary through Mason (`<Space>pm`)

### Adding New Formatters
1. Configure formatter in `lua/plugins/lang/conform.lua` under `formatters_by_ft`
2. Install formatter binary through Mason
3. Custom formatter behavior can be defined in the `formatters` table

### Adding New Plugins
1. Create `.lua` configuration file in appropriate `lua/plugins/` subdirectory
2. Add keymaps in `lua/core/keymaps.lua` using the `kmap()` function
3. Load keymaps in the plugin's `config` function
