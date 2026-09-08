# Neovim Keybindings Reference

Generated from the config in `shared/.config/nvim`. Leader key: `<Space>` (`lua/core/keymaps.lua:1`).

For the quick in-editor version, press `<leader>?` (renders `cheatsheet.txt`).

> No user commands (`nvim_create_user_command`) are defined in this config — all custom functionality is bound directly to keymaps.

## General

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `jk` | Exit insert mode (`<Esc>`) | i | lua/core/keymaps.lua |
| `jk` | Exit visual mode (`<Esc>`) | v | lua/core/keymaps.lua |
| `J` | Move selection down (`:m '>+1`) | v | lua/core/keymaps.lua |
| `K` | Move selection up (`:m '<-2`) | v | lua/core/keymaps.lua |
| `<leader>nh` | Clear search highlights (`:noh`) | n | lua/core/keymaps.lua |
| `<leader>th` | Choose theme (`:Themery`) | n | lua/core/keymaps.lua |
| `<leader>sp` | Toggle spell checker | n | lua/core/keymaps.lua |
| `<Esc>` | Exit terminal mode (`<C-\><C-n>`) | t | lua/core/keymaps.lua |
| `<leader>?` | Open keymaps cheatsheet (floating) | n | lua/core/cheatsheet.lua |
| `<leader>ec` | Edit cheatsheet.txt (vsplit) | n | lua/core/cheatsheet.lua |
| `q` / `<Esc>` | Close cheatsheet float (buffer-local) | n | lua/core/cheatsheet.lua |

## Buffer / Window Management

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<C-h>` | Navigate left (`TmuxNavigateLeft`) | n | lua/plugins/tmux.lua |
| `<C-j>` | Navigate down (`TmuxNavigateDown`) | n | lua/plugins/tmux.lua |
| `<C-k>` | Navigate up (`TmuxNavigateUp`) | n | lua/plugins/tmux.lua |
| `<C-l>` | Navigate right (`TmuxNavigateRight`) | n | lua/plugins/tmux.lua |
| `<C-\>` | Navigate to previous (`TmuxNavigatePrevious`) | n | lua/plugins/tmux.lua |
| `<leader>sv` | Split vertical (`:vsplit`) | n | lua/core/keymaps.lua |
| `<leader>sh` | Split horizontal (`:split`) | n | lua/core/keymaps.lua |
| `<leader>sm` | Toggle maximize pane (`:MaximizerToggle`) | n | lua/core/keymaps.lua |

## File Explorer (Oil)

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `-` | Open Oil in float (`:Oil --float`) | n | lua/plugins/oil.lua |
| `q` / `<ESC>` | Close Oil (buffer-local) | n | lua/plugins/oil.lua |
| `<C-r>` | Refresh Oil file list (buffer-local) | n | lua/plugins/oil.lua |

## Telescope / Picker

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<leader>ff` | Find files | n | lua/plugins/telescope.lua |
| `<leader>fg` | Live grep | n | lua/plugins/telescope.lua |
| `<leader>fb` | Find buffers | n | lua/plugins/telescope.lua |
| `<leader>fh` | Search help tags | n | lua/plugins/telescope.lua |
| `<leader>ft` | Find TODOs (`:TodoTelescope`) | n | lua/plugins/telescope.lua |
| `<leader>fc` | Find Templ components (live grep "templ ") | n | lua/plugins/telescope.lua |
| `<C-k>` | Move selection up (in picker) | i | lua/plugins/telescope.lua |
| `<C-j>` | Move selection down (in picker) | i | lua/plugins/telescope.lua |
| `<C-q>` | Send results to quickfix + open list | i | lua/plugins/telescope.lua |
| `<ESC>` | Close picker | i | lua/plugins/telescope.lua |

## LSP (buffer-local, on LspAttach)

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `gd` | Goto definition | n | lua/plugins/lspconfig.lua |
| `K` | Hover documentation | n | lua/plugins/lspconfig.lua |
| `gr` | Goto references (Telescope) | n | lua/plugins/lspconfig.lua |
| `gi` | Goto implementation (Telescope) | n | lua/plugins/lspconfig.lua |
| `gt` | Goto type definition (Telescope) | n | lua/plugins/lspconfig.lua |
| `<leader>dd` | Document diagnostics (Telescope) | n | lua/plugins/lspconfig.lua |
| `<leader>ds` | Document symbols (Telescope) | n | lua/plugins/lspconfig.lua |
| `[d` | Previous diagnostic | n | lua/plugins/lspconfig.lua |
| `]d` | Next diagnostic | n | lua/plugins/lspconfig.lua |
| `<leader>ee` | Line diagnostics (float) | n | lua/plugins/lspconfig.lua |
| `<leader>rn` | Rename symbol | n | lua/plugins/lspconfig.lua |
| `<leader>ca` | Code action | n | lua/plugins/lspconfig.lua |
| `<C-h>` | Signature help | i | lua/plugins/lspconfig.lua |

## Diagnostics / Quickfix (global)

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<leader>xl` | Open quickfix list (`:copen`) | n | lua/plugins/lspconfig.lua |
| `<leader>xc` | Close quickfix list (`:cclose`) | n | lua/plugins/lspconfig.lua |
| `[q` | Previous quickfix item (centered) | n | lua/plugins/lspconfig.lua |
| `]q` | Next quickfix item (centered) | n | lua/plugins/lspconfig.lua |
| `<leader>xd` | Send diagnostics to quickfix | n | lua/plugins/lspconfig.lua |

## Git

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<leader>lg` | Open Lazygit (snacks.nvim) | n | lua/plugins/snacks.lua |

## Formatting / Linting

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<leader>fm` | Format file or range (conform.nvim) | n, v | lua/plugins/conform.lua |
| `<leader>l` | Trigger linting for current file | n | lua/plugins/linting.lua |

## Go

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<leader>ih` | Toggle inlay hints | n | lua/plugins/go.lua |

## SQL / Database

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<leader>sq` | Insert SQL block (with treesitter injection) | n | lua/core/sql.lua |
| `<leader>st` | Toggle SQL results window (Dadbod) | n | lua/core/sql.lua |
| `<leader>du` | Toggle DBUI sidebar (`:DBUIToggle`) | n | lua/core/sql.lua |

## Zettelkasten / Notes

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<leader>zb` | Search notes (Telescope, opens floating note) | n | lua/core/keymaps.lua |
| `<leader>zw` | Quick capture new note | n | lua/core/keymaps.lua |
| `<leader>zl` | Insert link to note | n | lua/core/keymaps.lua |
| `<leader>zc` | Discover connections | n | lua/core/keymaps.lua |
| `<leader>zf` | Follow link | n | lua/core/keymaps.lua |
| `<leader>zr` | Rename note | n | lua/core/keymaps.lua |
| `<leader>zd` | Open daily Zettel log | n | lua/core/keymaps.lua |
| `]n` | Next note | n | lua/core/keymaps.lua |
| `[n` | Previous note | n | lua/core/keymaps.lua |
| `q` / `<Esc>` | Save & close floating note (buffer-local, `:x`) | n | lua/utils/zettelkasten.lua |
| `<leader>x` | Toggle checkbox `[ ]`/`[x]` (buffer-local in note) | n | lua/utils/zettelkasten.lua |

## AI (gen.nvim + Ollama)

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<leader>aq` | Open Qwen menu (qwen2.5-coder:14b) | n, v | lua/core/keymaps.lua |
| `<leader>ac` | Quick chat with Qwen | n | lua/core/keymaps.lua |
| `<leader>ag` | Qwen: generate component (selection) | v | lua/core/keymaps.lua |
| `<leader>ad` | Open DeepSeek menu (deepseek-r1:14b) | n, v | lua/core/keymaps.lua |
| `<leader>ar` | DeepSeek: deep reasoning (selection) | v | lua/core/keymaps.lua |
| `<leader>as` | DeepSeek: analyze project structure | n | lua/core/keymaps.lua |

## Terminal

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<leader>fp` | Floating popup terminal (tmux + zsh) | n | lua/core/keymaps.lua |
| `<Esc>` | Detach tmux & close popup (buffer-local) | t | lua/utils/terminal.lua |

## Todo Comments

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `]t` | Next todo comment | n | lua/plugins/todo.lua |
| `[t` | Previous todo comment | n | lua/plugins/todo.lua |

## Completion (blink.cmp)

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `<Tab>` | Snippet forward / next item / fallback | i | lua/plugins/cmp.lua |
| `<S-Tab>` | Snippet backward / previous item / fallback | i | lua/plugins/cmp.lua |

## Surround (mini.surround defaults)

| Keybinding | Action/Command | Mode | File Source |
|---|---|---|---|
| `sa` | Add surrounding (e.g. `saiw)`) | n, v | lua/plugins/mini.lua |
| `sd` | Delete surrounding (e.g. `sd'`) | n | lua/plugins/mini.lua |
| `sr` | Replace surrounding (e.g. `sr)'`) | n | lua/plugins/mini.lua |
| `sf` / `sF` | Find surrounding (forward / backward) | n | lua/plugins/mini.lua |
| `sh` | Highlight surrounding | n | lua/plugins/mini.lua |

---

## Notes

- **Inactive bindings**: `<leader>oo` and `<leader>oG` (ollama.nvim) are defined in `lua/plugins/ollama.lua` but the plugin is disabled (`enabled = false`).
- **Parked code**: the GoTH dev keymaps (`<leader>dd/dr/ds/dl/dt/dc`) in `lua/core/goth.lua` are commented out — `goth.setup()` currently registers nothing. The `cheatsheet.txt` entries for Templ/Tailwind (`<leader>tr/tf/go/tw/rf`) refer to these and are inactive until re-enabled.
- `<C-h/j/k/l>` work both inside Neovim and across tmux panes via vim-tmux-navigator.
