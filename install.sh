#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_BIN="$HOME/.local/bin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info() { echo -e "${CYAN}::${NC} $1"; }
success() { echo -e "${GREEN}::${NC} $1"; }
warn() { echo -e "${YELLOW}::${NC} $1"; }
error() { echo -e "${RED}::${NC} $1"; }

# Presets
preset_work() {
    GIT_NAME="Sam Batschelet"
    GIT_EMAIL="sbatsche@redhat.com"
    GIT_SIGNING_KEY="85E2EAD14C6212C9"
}

preset_personal() {
    GIT_NAME="Sam Batschelet"
    GIT_EMAIL="sbatschelet@gmail.com"
    GIT_SIGNING_KEY=""
}

# Parse arguments
PRESET=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --work)
            PRESET="work"
            preset_work
            shift
            ;;
        --personal)
            PRESET="personal"
            preset_personal
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--work|--personal]"
            echo ""
            echo "Options:"
            echo "  --work      Use work presets (sbatsche@redhat.com, GPG signing)"
            echo "  --personal  Use personal presets (sbatschelet@gmail.com)"
            echo "  (no args)   Interactive mode"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Interactive mode if no preset
if [ -z "$PRESET" ]; then
    echo ""
    info "Dotfiles installer"
    echo ""
    echo "Select a preset:"
    echo "  1) work     - sbatsche@redhat.com (GPG signed commits)"
    echo "  2) personal - sbatschelet@gmail.com"
    echo "  3) custom   - enter your own values"
    echo ""
    read -p "Choice [1-3]: " choice

    case $choice in
        1)
            preset_work
            PRESET="work"
            ;;
        2)
            preset_personal
            PRESET="personal"
            ;;
        3)
            read -p "Name: " GIT_NAME
            read -p "Email: " GIT_EMAIL
            read -p "GPG signing key (leave empty to disable): " GIT_SIGNING_KEY
            PRESET="custom"
            ;;
        *)
            error "Invalid choice"
            exit 1
            ;;
    esac
fi

echo ""
info "Installing with $PRESET profile"
info "  Name: $GIT_NAME"
info "  Email: $GIT_EMAIL"
[ -n "$GIT_SIGNING_KEY" ] && info "  GPG Key: $GIT_SIGNING_KEY"
echo ""

# Create directories
mkdir -p "$CONFIG_DIR"
mkdir -p "$LOCAL_BIN"

# Symlink function
link_config() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -e "$dest" ]; then
        warn "Backing up existing $dest to ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    success "Linked $dest"
}

# Install shared configs
info "Installing shared configs..."

link_config "$DOTFILES_DIR/shared/sway/config" "$CONFIG_DIR/sway/config"
link_config "$DOTFILES_DIR/shared/foot/foot.ini" "$CONFIG_DIR/foot/foot.ini"
link_config "$DOTFILES_DIR/shared/starship.toml" "$CONFIG_DIR/starship.toml"
link_config "$DOTFILES_DIR/shared/waybar/config" "$CONFIG_DIR/waybar/config"
link_config "$DOTFILES_DIR/shared/waybar/style.css" "$CONFIG_DIR/waybar/style.css"
link_config "$DOTFILES_DIR/shared/mako/config" "$CONFIG_DIR/mako/config"
link_config "$DOTFILES_DIR/shared/kanshi/config" "$CONFIG_DIR/kanshi/config"
link_config "$DOTFILES_DIR/shared/wofi/config" "$CONFIG_DIR/wofi/config"
link_config "$DOTFILES_DIR/shared/wofi/style.css" "$CONFIG_DIR/wofi/style.css"

# Install scripts
info "Installing scripts..."

for script in "$DOTFILES_DIR/scripts/"*; do
    [ -f "$script" ] || continue
    name="$(basename "$script")"
    link_config "$script" "$LOCAL_BIN/$name"
    chmod +x "$script"
done

# Install vm templates
info "Installing VM templates..."
VM_TEMPLATES_DIR="$HOME/.local/share/vm/templates/cloud-init"
mkdir -p "$VM_TEMPLATES_DIR"
for tmpl in "$DOTFILES_DIR/scripts/vm-templates/"*; do
    [ -f "$tmpl" ] || continue
    name="$(basename "$tmpl")"
    link_config "$tmpl" "$VM_TEMPLATES_DIR/$name"
done

# Generate gitconfig
info "Generating gitconfig..."

gitconfig="$HOME/.gitconfig"
if [ -e "$gitconfig" ] && [ ! -L "$gitconfig" ]; then
    warn "Backing up existing $gitconfig to ${gitconfig}.bak"
    mv "$gitconfig" "${gitconfig}.bak"
fi

# Build gitconfig from template
cat > "$gitconfig" << EOF
[user]
	name = $GIT_NAME
	email = $GIT_EMAIL
EOF

if [ -n "$GIT_SIGNING_KEY" ]; then
    cat >> "$gitconfig" << EOF
	signingkey = $GIT_SIGNING_KEY
EOF
fi

cat >> "$gitconfig" << EOF
[init]
	defaultBranch = main
[alias]
	last = log -1
	st = status
	co = checkout
	br = branch
	ci = commit
	lg = log --oneline --graph --decorate
[core]
	pager = less
EOF

if [ -n "$GIT_SIGNING_KEY" ]; then
    cat >> "$gitconfig" << EOF
[commit]
	gpgsign = true
EOF
fi

success "Created $gitconfig"

# Install starship if not present
info "Checking for starship..."
if ! command -v starship &>/dev/null && [ ! -x "$LOCAL_BIN/starship" ]; then
    info "Installing starship to $LOCAL_BIN..."
    curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir "$LOCAL_BIN" -y
    success "Starship installed"
else
    success "Starship already installed"
fi

# Bashrc starship init
info "Checking bashrc for starship..."
if ! grep -q 'starship init bash' "$HOME/.bashrc" 2>/dev/null; then
    echo "" >> "$HOME/.bashrc"
    echo '# Starship prompt' >> "$HOME/.bashrc"
    echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
    success "Added starship init to ~/.bashrc"
else
    success "Starship already in ~/.bashrc"
fi

echo ""
success "Installation complete!"
echo ""
info "Notes:"
echo "  - Configs are symlinked, edit files in $DOTFILES_DIR"
echo "  - Reload sway: \$mod+Shift+c"
echo "  - Original files backed up with .bak extension"
