# dotfiles

Personal dotfiles for Fedora + Sway/Wayland setup. Designed for multi-user setup (work/personal) with shared configs.

## Quick Start

```bash
git clone git@github.com:hexfusion/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --personal   # or --work
```

## Structure

```
dotfiles/
├── shared/              # Configs identical across users
│   ├── sway/           # Sway window manager
│   ├── foot/           # Terminal emulator
│   ├── waybar/         # Status bar
│   ├── mako/           # Notifications
│   ├── kanshi/         # Display management
│   ├── wofi/           # App launcher
│   └── starship.toml   # Shell prompt
├── scripts/            # CLI tools
│   ├── cpu-temp        # CPU temp for waybar
│   ├── random-wallpaper
│   ├── gc              # git commit -s -S wrapper
│   ├── vm              # libvirt VM management
│   ├── design          # Design doc tooling wrapper
│   ├── newproject      # Project scaffolding
│   └── vm-templates/   # cloud-init templates for vm
├── templates/          # User-specific templates
│   └── gitconfig.template
└── install.sh          # Installer
```

## Install Options

```bash
./install.sh --work      # sbatsche@redhat.com, GPG signing enabled
./install.sh --personal  # sbatschelet@gmail.com
./install.sh             # Interactive mode
```

## What Gets Installed

**Symlinked to ~/.config/:**
- sway/config
- foot/foot.ini
- starship.toml
- waybar/{config,style.css}
- mako/config
- kanshi/config
- wofi/{config,style.css}

**Symlinked to ~/.local/bin/:**
- cpu-temp, random-wallpaper, gc, vm, design, newproject

**Generated (not symlinked):**
- ~/.gitconfig - from template with user-specific values

## VM Tool Setup

The `vm` script requires RHEL subscription credentials for RHEL VMs:

```bash
# Add to ~/.bashrc or ~/.bash_profile
export RHEL_ORG="your-org-id"
export RHEL_ACTIVATION_KEY="your-key"
```

Also requires:
- Base images in `~/.local/share/vm-images/` (e.g., `rhel9.7.qcow2`)
- libvirt/qemu setup with user access

## Multi-User Setup

For separate work/personal users on same machine:

1. Create second user: `sudo useradd -m sbatschelet`
2. Clone dotfiles to new user's home
3. Run installer with appropriate preset

Both users share the same configs via symlinks to the dotfiles repo.

## Key Bindings (Sway)

| Key | Action |
|-----|--------|
| Super+Return | Terminal (foot) |
| Super+W | App launcher (wofi) |
| Super+B | Browser (firefox) |
| Super+M | File manager (nautilus) |
| Super+S | Screenshot (region + annotate) |
| Super+Shift+S | Screenshot (region + save) |
| Super+H/J/K/L | Focus left/down/up/right |
| Super+1-0,-,= | Workspaces 1-12 |
| Super+Shift+Q | Kill window |
| Super+Shift+C | Reload config |
| Super+Shift+X | Lock screen |

## Dependencies

```bash
# Core
sudo dnf install sway waybar foot mako kanshi wofi swaylock swayidle

# Utils
sudo dnf install grim slurp swappy brightnessctl playerctl jq

# Fonts
sudo dnf install google-noto-sans-mono-fonts

# VM tool
sudo dnf install libvirt qemu-kvm virt-install genisoimage
```
