#!/bin/bash
# Sync live configs from this machine into the dotfiles repo.
#
# NOTE: github.com/hexfusion/dotfiles is a PUBLIC repo. Everything copied by
# this script becomes world-readable on the next push. A secret scan runs at
# the end and aborts before you can commit if anything sensitive slipped in.
set -uo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_BIN="$HOME/.local/bin"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info() { echo -e "${CYAN}::${NC} $1"; }
success() { echo -e "${GREEN}::${NC} $1"; }
warn() { echo -e "${YELLOW}::${NC} $1"; }
error() { echo -e "${RED}::${NC} $1"; }

# Copy only if the source exists. A missing file is a warning, not a fatal
# error: previously `set -e` aborted the whole sync partway through, silently
# skipping every step after the first missing file.
copy() {
    local src="$1" dest="$2"
    if [ ! -e "$src" ]; then
        warn "skip (missing): $src"
        return 0
    fi
    # If dest is a symlink back to src, install.sh already linked it: nothing to do.
    if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
}

info "Syncing configs..."
copy "$CONFIG_DIR/sway/config"              "$DOTFILES_DIR/shared/sway/config"
copy "$CONFIG_DIR/foot/foot.ini"            "$DOTFILES_DIR/shared/foot/foot.ini"
copy "$CONFIG_DIR/starship.toml"            "$DOTFILES_DIR/shared/starship.toml"
copy "$CONFIG_DIR/waybar/config"            "$DOTFILES_DIR/shared/waybar/config"
copy "$CONFIG_DIR/waybar/style.css"         "$DOTFILES_DIR/shared/waybar/style.css"
copy "$CONFIG_DIR/mako/config"              "$DOTFILES_DIR/shared/mako/config"
copy "$CONFIG_DIR/kanshi/config"            "$DOTFILES_DIR/shared/kanshi/config"
copy "$CONFIG_DIR/wofi/config"              "$DOTFILES_DIR/shared/wofi/config"
copy "$CONFIG_DIR/wofi/style.css"           "$DOTFILES_DIR/shared/wofi/style.css"
copy "$CONFIG_DIR/zellij/config.kdl"        "$DOTFILES_DIR/shared/zellij/config.kdl"
copy "$CONFIG_DIR/zellij/layouts/design.kdl" "$DOTFILES_DIR/shared/zellij/layouts/design.kdl"
copy "$CONFIG_DIR/broot/conf.hjson"         "$DOTFILES_DIR/shared/broot/conf.hjson"
copy "$CONFIG_DIR/broot/verbs.hjson"        "$DOTFILES_DIR/shared/broot/verbs.hjson"
copy "$CONFIG_DIR/lazygit/config.yml"       "$DOTFILES_DIR/shared/lazygit/config.yml"
copy "$HOME/.vimrc"                         "$DOTFILES_DIR/shared/vimrc"

# Custom scripts only. Downloaded binaries (kubectl, helm, uv, starship, ...)
# and Python venv shims (tqdm, ttx, typer, transformers, ...) are deliberately
# excluded: they are installed by install.sh or by their own tooling.
info "Syncing scripts..."
SCRIPTS=(
    battery-alert
    broot-tab
    btrfs-space-check
    claude-tab
    cpu-temp
    design
    download-space-wallpapers
    editor-pane
    flameshot-sway
    gc
    newproject
    open
    open-in-vim
    random-wallpaper
    rename-workspace
    resign
    smart-open
    vm
    workbench-clear-marker
    zd
    zellij-edit
)
for name in "${SCRIPTS[@]}"; do
    copy "$LOCAL_BIN/$name" "$DOTFILES_DIR/scripts/$name"
done

# ---------------------------------------------------------------------------
# Secret scan. This repo is public, so treat any hit as fatal.
# ---------------------------------------------------------------------------
info "Scanning for secrets..."

PATTERNS='(ghp_|gho_|ghs_|github_pat_)[A-Za-z0-9_]{20,}
sk-[A-Za-z0-9]{20,}
hf_[A-Za-z0-9]{20,}
AKIA[0-9A-Z]{16}
glpat-[A-Za-z0-9_-]{20,}
-----BEGIN [A-Z ]*PRIVATE KEY-----
(ACTIVATION_KEY|ACTIVATIONKEY)["'"'"']?\s*[=:]\s*["'"'"']?[A-Za-z0-9-]{8,}
(_TOKEN|_SECRET|_PASSWORD|_APIKEY|_API_KEY)["'"'"']?\s*[=:]\s*["'"'"']?[A-Za-z0-9+/_.-]{8,}
Bearer\s+[A-Za-z0-9._-]{20,}
[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'

FOUND=0
while IFS= read -r pat; do
    [ -z "$pat" ] && continue
    # Ignore shell-safe empty defaults like ${FOO_TOKEN:-} and :-} placeholders.
    # -e is required: patterns beginning with "-" (e.g. the PRIVATE KEY header)
    # would otherwise be parsed by grep as options and silently never match.
    hits=$(grep -rInE -e "$pat" --exclude-dir=.git "$DOTFILES_DIR" 2>/dev/null \
        | grep -vE ':-\}|:=\}|your-key|YOUR_|example|placeholder|<[a-z-]+>' || true)
    if [ -n "$hits" ]; then
        [ $FOUND -eq 0 ] && error "Potential secrets found. NOT safe to commit:"
        echo "$hits" | sed 's/^/    /'
        FOUND=1
    fi
done <<< "$PATTERNS"

if [ $FOUND -eq 1 ]; then
    echo ""
    error "Aborting. Move these values into an untracked file"
    error "(e.g. ~/.config/vm/credentials.env, mode 0600) and re-run."
    exit 1
fi

success "No secrets detected."
success "Sync complete. Review with: git -C $DOTFILES_DIR diff"
