#!/bin/bash
# Sync live configs from this machine into the dotfiles repo
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_BIN="$HOME/.local/bin"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

info() { echo -e "${CYAN}::${NC} $1"; }
success() { echo -e "${GREEN}::${NC} $1"; }

# Configs to sync
info "Syncing configs..."
cp "$CONFIG_DIR/sway/config" "$DOTFILES_DIR/shared/sway/config"
cp "$CONFIG_DIR/foot/foot.ini" "$DOTFILES_DIR/shared/foot/foot.ini"
cp "$CONFIG_DIR/starship.toml" "$DOTFILES_DIR/shared/starship.toml"
cp "$CONFIG_DIR/waybar/config" "$DOTFILES_DIR/shared/waybar/config"
cp "$CONFIG_DIR/waybar/style.css" "$DOTFILES_DIR/shared/waybar/style.css"
cp "$CONFIG_DIR/mako/config" "$DOTFILES_DIR/shared/mako/config"
cp "$CONFIG_DIR/kanshi/config" "$DOTFILES_DIR/shared/kanshi/config"
cp "$CONFIG_DIR/wofi/config" "$DOTFILES_DIR/shared/wofi/config"
cp "$CONFIG_DIR/wofi/style.css" "$DOTFILES_DIR/shared/wofi/style.css"
cp "$CONFIG_DIR/zellij/config.kdl" "$DOTFILES_DIR/shared/zellij/config.kdl"
mkdir -p "$DOTFILES_DIR/shared/zellij/layouts"
cp "$CONFIG_DIR/zellij/layouts/design.kdl" "$DOTFILES_DIR/shared/zellij/layouts/design.kdl"
cp "$CONFIG_DIR/broot/conf.hjson" "$DOTFILES_DIR/shared/broot/conf.hjson"
cp "$CONFIG_DIR/broot/verbs.hjson" "$DOTFILES_DIR/shared/broot/verbs.hjson"
cp "$CONFIG_DIR/lazygit/config.yml" "$DOTFILES_DIR/shared/lazygit/config.yml"
cp "$HOME/.vimrc" "$DOTFILES_DIR/shared/vimrc"

# Scripts to sync (only custom scripts, not downloaded binaries)
info "Syncing scripts..."
SCRIPTS=(claude-tab zd cpu-temp design gc newproject random-wallpaper rename-workspace vm download-space-wallpapers)
for name in "${SCRIPTS[@]}"; do
    if [ -f "$LOCAL_BIN/$name" ]; then
        cp "$LOCAL_BIN/$name" "$DOTFILES_DIR/scripts/$name"
    fi
done

success "Sync complete. Review changes with: git -C $DOTFILES_DIR diff"
