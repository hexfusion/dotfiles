# Terminal Workflow Cheatsheet

## Sway (Window Manager)

| Key | Action |
|-----|--------|
| Super+z | Launch/attach zellij workspace |
| Super+Return | New foot terminal |
| Super+b | Browser |
| Super+o | gh dash |
| Super+w | App launcher (wofi) |
| Super+1-9 | Switch Sway workspace |
| Super+Shift+q | Kill window |
| Super+Shift+c | Reload Sway config |
| Super+h/j/k/l | Focus window |
| Super+s | Screenshot (annotate) |

## Zellij (Terminal Workspace)

| Key | Action |
|-----|--------|
| Alt+1-9 | Switch to tab N |
| Alt+Shift+4 | Rename current tab |
| Alt+h | Focus left pane (broot) |
| Alt+l | Focus right pane (shell/agent) |
| Alt+f | Toggle floating panes |
| Ctrl+t, n | New tab |
| Ctrl+p, x | Close pane |
| Ctrl+n, h/l | Resize pane |
| Ctrl+o, d | Detach session |
| Ctrl+q | Quit zellij |

## Claude (AI Agent)

| Command | Action |
|---------|--------|
| `c` | Start/resume Claude session (named after tab) |
| `c myproject` | Rename tab + start/resume Claude |
| `/status` | Show session info inside Claude |
| `/exit` | Exit Claude session |

Session map persists at `~/.config/zellij/claude-sessions`.

## Broot (File Browser - Left Sidebar)

| Key/Command | Action |
|-------------|--------|
| Enter (on dir) | Expand/collapse directory |
| Enter (on file) | Open in vim (floating pane) |
| Esc | Go back / close |
| j/k | Navigate up/down |
| Type text | Fuzzy search/filter |
| `:diff` | Toggle: show only changed files |
| `:gd` | Show git diff for selected file |
| `:cd /path` | Jump to directory |
| `:gtr` | Jump to git root |
| `:rm` | Delete selected file |
| `:q` | Quit broot |

Broot remembers its directory per tab across reboots (`~/.config/zellij/broot-dirs`).

## Vim (Editor)

| Key/Command | Action |
|-------------|--------|
| `:diff` or `:gd` | Fugitive split diff (focuses working copy) |
| `:Git` | Git status view (stage with `-`, commit with `cc`) |
| `:Git log` | Log view |
| `:Git blame` | Inline blame |
| `:q` | Quit (closes floating pane back to broot) |
| `do` | Rollback current hunk (get from git version) |
| `dp` | Push current hunk to other side |
| `]c` / `[c` | Jump to next/prev change |
| Ctrl+w, h/l | Switch between diff split panes |

## Git (Shell)

| Command | Action |
|---------|--------|
| `git diff` | Pretty diff via delta |
| `git log` | Log with delta formatting |
| `lazygit` | Full git TUI (tab 9) |

## Quick Flows

**Start working:**
```
Super+z              # open zellij
Alt+1                # go to tab 1
c                    # start/resume Claude
```

**Browse and edit files:**
```
Alt+h                # focus broot sidebar
(navigate to file)
Enter                # open in vim (floating)
:diff                # see git diff split
:q                   # back to broot
```

**Review changes:**
```
Alt+h                # focus broot
:diff                # filter to changed files only
Enter                # open changed file
:diff                # see the diff
:q                   # back to broot
:diff                # toggle back to all files
```

**Switch projects:**
```
Alt+7                # go to empty tab
Alt+Shift+4          # rename tab
c                    # start Claude in new project context
Alt+h                # broot, navigate to new repo
```

**After reboot:**
```
Super+z              # recreates zellij from layout
Alt+N                # go to your tab
c                    # resumes exact Claude session
```
