# Neovim Keybindings Cheat Sheet

> Leader key: `<Space>`
>
> **TIP:** Press `<leader>?` in Neovim for an in-editor floating cheatsheet!

## Navigation

### Window/Split Navigation
| Key | Action |
|-----|--------|
| `<C-h>` | Navigate left (works across tmux) |
| `<C-j>` | Navigate down (works across tmux) |
| `<C-k>` | Navigate up (works across tmux) |
| `<C-l>` | Navigate right (works across tmux) |
| `<leader>wf` | Toggle Focus Mode (golden ratio) |

### Harpoon (Quick File Switching)
| Key | Action |
|-----|--------|
| `<leader>A` | Add file to Harpoon |
| `<leader>h` | Open Harpoon menu |
| `<leader>1-5` | Jump to Harpoon file 1-5 |
| `[H` | Previous Harpoon file |
| `]H` | Next Harpoon file |

### File Explorer
| Key | Action |
|-----|--------|
| `<leader>e` | Neo-tree file explorer |

### Buffer Navigation
| Key | Action |
|-----|--------|
| `<leader>,` | Switch buffer (Telescope) |
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bd` | Delete buffer |

---

## Search & Find

### Telescope
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fF` | Find files (current dir) |
| `<leader>fg` | Find files (git) |
| `<leader>fr` | Recent files |
| `<leader>sg` | Live grep |
| `<leader>sG` | Grep (current dir) |
| `<leader>sw` | Search word under cursor |
| `<leader>sb` | Search buffer |
| `<leader>st` | Search TODOs |
| `<leader>:` | Command history |
| `<leader>/` | Grep in project |

**Inside Telescope:**
| Key | Action |
|-----|--------|
| `<C-j>` | Move selection down |
| `<C-k>` | Move selection up |
| `<C-q>` | Send to quickfix |

### Search & Replace (Grug-far)
| Key | Action |
|-----|--------|
| `<leader>sr` | Search & Replace |
| `<leader>sR` | Search & Replace (current file) |
| `<leader>sw` | Search word under cursor |
| `<leader>sr` (visual) | Search selection |

**Inside Grug-far:**
| Key | Action |
|-----|--------|
| `<localleader>r` | Replace |
| `<localleader>q` | Send to quickfix |
| `<localleader>c` | Close |

---

## Code Editing

### Split/Join (TreeSJ)
| Key | Action |
|-----|--------|
| `<leader>j` | Toggle split/join |
| `<leader>cJ` | Split code block |
| `<leader>cj` | Join code block |

### Increment/Decrement (Dial)
| Key | Action |
|-----|--------|
| `<C-a>` | Increment (numbers, dates, booleans, etc.) |
| `<C-x>` | Decrement |
| `g<C-a>` | Increment (additive in visual) |
| `g<C-x>` | Decrement (additive in visual) |

**Works on:** numbers, hex, dates, booleans, true/false, yes/no, on/off, let/const, &&/||, semver

### Word Motions (Spider - CamelCase aware)
| Key | Action |
|-----|--------|
| `w` | Next word (respects camelCase) |
| `e` | End of word |
| `b` | Previous word |

### Folding (UFO)
| Key | Action |
|-----|--------|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zr` | Open folds except kinds |
| `zm` | Close folds with level |

---

## LSP (Lspsaga)

### Navigation
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to type definition |
| `gp` | Peek definition |
| `gP` | Peek type definition |
| `gf` | LSP finder (refs, defs, implementations) |

### Actions
| Key | Action |
|-----|--------|
| `K` | Hover doc |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename |
| `<leader>cR` | Rename (project-wide) |
| `<leader>cs` | Symbol outline |
| `<leader>ci` | Incoming calls |
| `<leader>co` | Outgoing calls |
| `<leader>cf` | Format |

### Diagnostics
| Key | Action |
|-----|--------|
| `<leader>xx` | Workspace diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xl` | Line diagnostics |
| `<leader>xc` | Cursor diagnostics |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `]t` | Next TODO |
| `[t` | Previous TODO |

---

## Git

### Gitsigns
| Key | Action |
|-----|--------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghR` | Reset buffer |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line |
| `<leader>ghd` | Diff this |
| `<leader>ghD` | Diff this ~ |
| `ih` | Select hunk (text object) |

### Diffview
| Key | Action |
|-----|--------|
| `<leader>gd` | Diff view (working tree) |
| `<leader>gD` | Diff view (last commit) |
| `<leader>gm` | Diff view (vs main) |
| `<leader>gf` | File history (current) |
| `<leader>gF` | File history (repo) |
| `<leader>gq` | Close diff view |
| `<leader>gB` | Branch files vs main |

### LazyGit
| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |

---

## AI (Avante via ACP)

| Key | Action |
|-----|--------|
| `<leader>aa` | Ask Avante |
| `<leader>ac` | Chat with Avante |
| `<leader>ae` | Edit with Avante |
| `<leader>at` | Toggle Avante |
| `<leader>af` | Focus Avante |
| `<leader>ah` | Avante history |
| `<leader>am` | Select model |
| `<leader>an` | New chat |
| `<leader>ap` | Switch provider (claude-code / cursor) |
| `<leader>ar` | Refresh Avante |
| `<leader>as` | Stop Avante |

---

## Task Runner (Overseer)

| Key | Action |
|-----|--------|
| `<leader>ot` | Toggle Overseer |
| `<leader>or` | Run task |
| `<leader>oq` | Quick action |
| `<leader>oa` | Task action |
| `<leader>ob` | Build |

---

## Sessions

| Key | Action |
|-----|--------|
| `<leader>qs` | Restore session |
| `<leader>qS` | Select session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save current session |

---

## UI Toggles

| Key | Action |
|-----|--------|
| `<leader>uC` | Change colorscheme |
| `<leader>z` | Zen mode |
| `<leader>Z` | Zen zoom |
| `<leader>un` | Notification history |
| `<leader>uD` | Toggle dim mode |

### Noice
| Key | Action |
|-----|--------|
| `<leader>snl` | Last message |
| `<leader>snh` | Message history |
| `<leader>sna` | All messages |
| `<leader>snd` | Dismiss all |
| `<S-Enter>` | Redirect cmdline (in cmdline mode) |

---

## Tmux Integration

| Key | Action |
|-----|--------|
| `<leader>tp` | Open tmux pane (file dir) |
| `<leader>tP` | Open tmux pane (project root) |
| `<leader>tw` | Open tmux window (file dir) |

---

## General

| Key | Action |
|-----|--------|
| `jk` | Exit insert mode |
| `<C-s>` | Save file |
| `<A-j>` | Move line down |
| `<A-k>` | Move line up |
| `q` | Close help/qf/man windows |

---

## Dashboard Shortcuts

| Key | Action |
|-----|--------|
| `f` | Find file |
| `n` | New file |
| `r` | Recent files |
| `g` | Find text |
| `s` | Restore session |
| `l` | Lazy (plugins) |
| `q` | Quit |
