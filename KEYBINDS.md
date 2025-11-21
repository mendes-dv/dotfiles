# Keybindings Reference

This document describes the unified keybindings between Zellij and Tmux for a consistent workflow.

## Zellij & Tmux Keybindings

Both Zellij and Tmux now share similar keybinding patterns for consistency.

### Mode Activation

| Mode | Zellij | Tmux | Description |
|------|--------|------|-------------|
| Pane | `Ctrl+s` | `Ctrl+s` (prefix) | Pane management and navigation |
| Tab/Window | `Ctrl+t` | `Ctrl+t` | Tab/window management |
| Session | `Ctrl+q` | `Ctrl+q` | Session management |
| Scroll/Copy | `Ctrl+b` | `Ctrl+b` | Scroll and copy mode |
| Resize | `Ctrl+r` (in pane mode) | `Ctrl+r` | Resize panes |

### Pane Mode (`Ctrl+s`)

| Key | Action | Notes |
|-----|--------|-------|
| `h/j/k/l` or arrows | Navigate between panes | Vim-style navigation |
| `v` | Split vertically (right) | Creates new pane to the right |
| `s` | Split horizontally (down) | Creates new pane below |
| `n` | New pane/window | |
| `x` | Close current pane | |
| `f` | Toggle fullscreen | |
| `p` | Focus previous pane | |

### Tab/Window Mode (`Ctrl+t`)

| Key | Action | Notes |
|-----|--------|-------|
| `h/j` or `Left/Down` | Previous tab/window | |
| `k/l` or `Up/Right` | Next tab/window | |
| `n` | New tab/window | |
| `c` | Rename tab/window | |
| `x` | Close tab/window | |
| `1-9` | Go to tab/window 1-9 | |
| `Tab` | Toggle to last tab/window | |

### Session Mode (`Ctrl+q`)

| Key | Action | Notes |
|-----|--------|-------|
| `d` | Detach from session | |
| `n` | New session | |
| `q` | Quit session | Asks for confirmation in Tmux |

### Resize Mode (`Ctrl+r`)

| Key | Action | Notes |
|-----|--------|-------|
| `h/j/k/l` or arrows | Resize pane in direction | |
| `+/=/- ` | Toggle zoom (Tmux only) | |

### Scroll/Copy Mode (`Ctrl+b`)

- In both Zellij and Tmux, this enters scroll/copy mode
- Use arrow keys or `h/j/k/l` to navigate
- In Zellij: `e` to edit scrollback, `s` to search
- In Tmux: Use vi-mode keys for selection

## Zellij Status Bar

The top bar in Zellij now displays:
- **Left**: Mode indicator, session name, **current working directory** (folder icon 󰉋), notifications
- **Center**: Tabs
- **Right**: Git branch, date/time

The current working directory helps identify which project/folder you're working in when splitting panes with files from different projects.

## Tips

1. **Muscle Memory**: The keybindings are now consistent between Zellij and Tmux, so you can switch between them without relearning.
2. **Mode-based**: Both tools use mode-based workflows - press the mode key, then the action key, then return to normal mode.
3. **Vim-style**: Navigation uses `hjkl` consistently across both tools.
4. **Context Awareness**: The folder display in Zellij helps you stay oriented when working with multiple projects.
