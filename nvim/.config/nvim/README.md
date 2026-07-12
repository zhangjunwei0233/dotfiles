# ZSVIM

ZSVIM is a small personal layer on top of [LazyVim](https://www.lazyvim.org/). LazyVim owns the editor distribution and compatibility work; this repository contains only personal mappings, options, autocmds, and focused plugin overrides.

The configuration is installed as part of the parent dotfiles repository with GNU Stow.

## Requirements

- Neovim 0.11.2 or newer
- Git, a C compiler, `curl`, `ripgrep`, `fd`, and `lazygit`
- A Nerd Font
- GNU Stow

Language servers, formatters, and debuggers may also require their corresponding runtimes, such as Python, Node.js, Go, or a JDK.

## Installation

From the dotfiles repository root:

```sh
stow nvim
nvim
```

On first launch, allow Lazy and Mason to finish installing dependencies. Restart Neovim and run `:checkhealth` if anything does not load.

## Configuration layout

```text
init.lua                  minimal entry point
lua/config/lazy.lua       lazy.nvim and LazyVim bootstrap
lua/config/options.lua    personal Neovim options
lua/config/keymaps.lua    personal keymaps and terminal behavior
lua/config/autocmds.lua   personal autocmds
lua/plugins/dashboard.lua ZSVIM dashboard header
lazyvim.json              extras selected through :LazyExtras
lazy-lock.json            known-working plugin revisions
```

Files under `lua/config/` are automatically loaded by LazyVim. Plugin specifications under `lua/plugins/` are automatically imported by lazy.nvim.

## Keymap design

`<leader>` is Space. `<localleader>` is `;`.

- `<leader>` triggers editor and plugin functionality.
- `;` changes the current layout or toggles a visible tool.
- `<C-h/j/k/l>` navigates windows in normal and terminal-input modes.
- `<C-n>` and `<C-p>` move between buffers.

Important personal mappings:

| Mapping | Action |
| --- | --- |
| `<leader>t` | Create a new bottom terminal in the current file's directory |
| `;t` | Hide or restore terminals created with `<leader>t` |
| `;m` | Toggle current-window zoom, including from terminal-input mode |
| `;-` / `;\\` | Create horizontal / vertical splits |
| `;q` / `;Q` | Close window / delete buffer |
| `;e` / `;s` / `;g` | Explorer / LSP symbols / Lazygit |
| `<leader>f...` | Finders and pickers |
| `<leader>l...` | LSP and diagnostic aliases |
| `<leader>s...` | Session aliases |
| `<leader>pp` / `pm` / `pc` | Lazy / Mason / Conform information |

Every `<leader>t` press creates a separate terminal. `;t` never creates one: it does nothing until at least one personal terminal exists, hides all visible personal terminals, and restores them when they are hidden. The terminal winbar is intentionally disabled.

Use WhichKey by pressing Space or `;` and waiting to inspect all current mappings, including LazyVim defaults.

## Routine maintenance

Before updating, make sure the dotfiles worktree is clean. Then:

1. Open `:Lazy` and press `U` to update plugins.
2. Restart Neovim.
3. Read the LazyVim changelog with `<leader>L`.
4. Run `:checkhealth` and open representative files to test LSP, completion, formatting, and Treesitter.
5. Review and commit the updated `lazy-lock.json`.

Useful commands:

| Command | Purpose |
| --- | --- |
| `:Lazy` | Inspect, update, install, and clean plugins |
| `:Lazy restore` | Restore revisions recorded in `lazy-lock.json` |
| `:LazyExtras` | Enable or disable upstream LazyVim feature bundles |
| `:Mason` | Manage external language and debugging tools |
| `:LspInfo` | Inspect language servers attached to the buffer |
| `:ConformInfo` | Inspect formatters for the current buffer |
| `:TSUpdate` | Update installed Treesitter parsers |
| `:checkhealth` | Run Neovim and plugin diagnostics |

Keep `lazy-lock.json` under version control. It is the reproducibility and rollback point when an upstream update breaks something.

## Extending the configuration

Prefer LazyVim's upstream integrations:

1. Check `:LazyExtras` for the language or feature.
2. Check LazyVim's current default mappings and plugin documentation.
3. Add only the missing personal behavior locally.

Use the following ownership boundaries:

- Put mappings in `lua/config/keymaps.lua`.
- Put options in `lua/config/options.lua`.
- Put autocmds in `lua/config/autocmds.lua`.
- Put plugin additions or `opts` overrides in a focused file under `lua/plugins/`.
- Do not copy an entire LazyVim plugin specification merely to change one option.

A minimal plugin override looks like this:

```lua
return {
  {
    "owner/plugin.nvim",
    opts = {
      some_option = true,
    },
  },
}
```

## Verification

Format and check local Lua changes before committing:

```sh
stylua lua
stylua --check lua
nvim --headless '+qa'
```

For a clean dependency test without changing the normal Neovim data directory:

```sh
XDG_DATA_HOME=/tmp/zsvim-data \
XDG_STATE_HOME=/tmp/zsvim-state \
XDG_CACHE_HOME=/tmp/zsvim-cache \
nvim --headless '+Lazy! sync' '+qa'
```

If the installation becomes unrecoverable, move the Neovim data, state, and cache directories aside and launch Neovim again. Do not delete them until the rebuilt installation is verified:

```sh
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
nvim
```
