# dotfiles

Personal dotfiles for Fedora + Sway/Wayland setup. Designed for multi-user setup (work/personal) with shared configs.

## Quick Start

```bash
git clone git@github.com:hexfusion/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --personal   # or --work
```

## Sync

Source of truth is the live machine. To sync changes back to the repo:

```bash
./sync.sh
```

### Key Bindings

| Key | Action |
|-----|--------|
| Super+z | Launch/attach zellij design session |
| Alt+1-9 | Switch to tab N (via Corne lower layer) |
| Alt+Shift+4 | Rename current tab |
| Alt+h/l | Prev/next tab |
| Ctrl+t, n | New tab |
| Ctrl+o, d | Detach session |

### Claude Integration

The `claude-tab` script (aliased to `c`) ties Claude Code sessions to zellij tab names:

```bash
c              # Resume claude session for this tab, or start new
c myproject    # Rename tab to "myproject", then resume/start
```

How it works:
- Names the Claude session after the zellij tab (`claude -n <tab>`)
- Saves a tab-to-session-ID mapping in `~/.config/zellij/claude-sessions`
- Background watcher syncs the mapping if you rename the tab while Claude runs
- On reboot: `Super+z` restores zellij, `c` in any tab resumes the right session

### Session Lifecycle

```
Super+z          --> zellij workspace (foot terminal)
Alt+N            --> switch to tab N
c                --> start/resume Claude (named after tab)
Alt+Shift+4      --> rename tab (syncs to session map live)
Ctrl+o, d        --> detach (processes keep running)
Super+z          --> reattach (everything preserved)
reboot + Super+z --> recreate from layout, `c` resumes sessions
```

## Key Bindings (Sway)

| Key | Action |
|-----|--------|
| Super+Return | Terminal (foot) |
| Super+z | Zellij workspace |
| Super+W | App launcher (wofi) |
| Super+B | Browser |
| Super+O | gh dash |
| Super+M | File manager (nautilus) |
| Super+S | Screenshot (region + annotate) |
| Super+Shift+S | Screenshot (region + save) |
| Super+H/J/K/L | Focus left/down/up/right |
| Super+1-0,-,= | Workspaces 1-12 |
| Super+Shift+Q | Kill window |
| Super+Shift+C | Reload config |
| Super+Shift+X | Lock screen |

## VM Tool Setup

The `vm` script requires RHEL subscription credentials for RHEL VMs:

```bash
# Add to ~/.bashrc or ~/.bash_profile
export RHEL_ORG="your-org-id"
export RHEL_ACTIVATION_KEY="your-key"
```

