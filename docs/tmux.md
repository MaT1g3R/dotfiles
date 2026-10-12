# Tmux Configuration

Modern, ergonomic tmux configuration crafted for Vim/Neovim users, featuring the **Base16 Oceanic Next** theme, seamless window navigation, system clipboard integration, and TPM plugin management.

---

## Key Bindings Reference

### Prefix Key
* **`Ctrl-Space`** (Prefix) — Replaces `Ctrl-b` for easy thumb reach without collision.

### Pane Management & Vim Navigation
| Action | Keybinding |
| :--- | :--- |
| **Seamless Pane Navigation** | `Alt-h` / `Alt-j` / `Alt-k` / `Alt-l` (No prefix needed) |
| **Vim Pane Navigation (Fallback)** | `Ctrl-Space` + `h` / `j` / `k` / `l` |
| **Resize Panes (5 cells)** | `Ctrl-Space` + `H` / `J` / `K` / `L` (Repeatable) |
| **Vertical Split (Side-by-side)** | `Ctrl-Space` + `\|` or `Ctrl-Space` + `v` |
| **Horizontal Split (Top-bottom)** | `Ctrl-Space` + `-` or `Ctrl-Space` + `s` |
| **Kill Pane** | `Ctrl-Space` + `x` |
| **Kill Window** | `Ctrl-Space` + `X` |
| **Toggle Synchronize Panes** | `Ctrl-Space` + `S` |

> *All new windows and splits preserve the current working directory.*

### Window & Session Management
| Action | Keybinding |
| :--- | :--- |
| **New Window** | `Ctrl-Space` + `c` |
| **Previous / Next Window** | `Ctrl-Space` + `Ctrl-h` / `Ctrl-Space` + `Ctrl-l` |
| **Reorder Window Left / Right** | `Ctrl-Space` + `<` / `Ctrl-Space` + `>` |
| **Toggle Last Window** | `Ctrl-Space` + `Tab` or `Ctrl-Space` + `` ` `` |
| **Reload Configuration** | `Ctrl-Space` + `r` |
| **Kill Session** | `Ctrl-Space` + `Q` (prompts confirmation) |

### Vi Copy Mode & Clipboard
| Action | Keybinding |
| :--- | :--- |
| **Enter Copy Mode** | `Ctrl-Space` + `Escape` or `Ctrl-Space` + `[` |
| **Begin Selection** | `v` |
| **Select Entire Line** | `V` |
| **Rectangle (Block) Toggle** | `Ctrl-v` |
| **Yank to System Clipboard** | `y` (uses `wl-copy` or `xclip`) |
| **Start / End of Line** | `H` / `L` |
| **Cancel / Exit Copy Mode** | `Escape` |
| **Paste Buffer** | `Ctrl-Space` + `p` |

---

## TPM Plugins & Session Persistence

The configuration includes TPM (Tmux Plugin Manager) with automatic bootstrapping:
* **`tmux-plugins/tpm`**: Plugin manager core
* **`tmux-plugins/tmux-sensible`**: Sensible tmux baseline settings
* **`tmux-plugins/tmux-resurrect`**: Session persistence (persists windows, splits, and Neovim sessions)
* **`tmux-plugins/tmux-continuum`**: Auto-saves every 15 mins and restores tmux sessions on start
* **`tmux-plugins/tmux-yank`**: Seamless system clipboard copying

### Plugin Shortcuts
* **`Ctrl-Space` + `I`**: Install and refresh plugins
* **`Ctrl-Space` + `U`**: Update installed plugins
* **`Ctrl-Space` + `Ctrl-s`**: Manually save current tmux environment
* **`Ctrl-Space` + `Ctrl-r`**: Manually restore saved tmux environment

---

## Base16 Oceanic Next Theme & Pane Styling

The status bar and pane borders are styled to match Neovim's `base16-oceanicnext` colorscheme and Powerline symbols (``, ``, ``, ``):
* **Active Window / Active Pane Accent**: Oceanic Cyan (`#5fb3b3`, bold)
* **Active Pane Highlighting**:
  * Heavy box-drawing borders (`pane-border-lines heavy`)
  * Directional indicator arrows (`pane-border-indicators both`) pointing toward the focused pane
  * Dynamic top border badge (`#P  command`) highlighting the active pane (automatically shown when multiple panes are present, hidden when single pane or zoomed)
* **Session Tab**: Oceanic Blue (`#6699cc`)
* **Sync Mode Alert**: Oceanic Yellow (`#fac863`)
* **Status Bar Base**: Oceanic Dark (`#1b2b34`)


---

## Neovim Bidirectional Navigation (Optional)

To enable seamless jumping across Neovim splits and tmux panes using `Alt-hjkl` directly from within Neovim:

```vim
" In your ~/.config/nvim/init.vim:
Plug 'christoomey/vim-tmux-navigator'

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
```
