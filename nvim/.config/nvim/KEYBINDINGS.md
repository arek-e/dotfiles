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
| `K` | Peek fold or LSP hover |

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

## Diagnostics & Trouble

| Key | Action |
|-----|--------|
| `<leader>xx` | Diagnostics (Trouble) |
| `<leader>xX` | Buffer diagnostics (Trouble) |
| `<leader>cs` | Symbols (Trouble) |
| `<leader>xL` | Location list (Trouble) |
| `<leader>xQ` | Quickfix list (Trouble) |
| `<leader>xt` | Todo (Trouble) |
| `<leader>xT` | Todo/Fix/Fixme (Trouble) |
| `]t` | Next TODO |
| `[t` | Previous TODO |

---

## AI (Claude Code)

| Key | Action |
|-----|--------|
| `<C-,>` | Toggle Claude Code |
| `<leader>ac` | Open Claude Code |
| `<leader>aC` | Claude Continue |
| `<leader>aR` | Claude Resume |

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

## LSP (LazyVim Defaults)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover (or peek fold) |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename |
| `<leader>cf` | Format |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |

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
