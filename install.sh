#!/bin/bash
# Install orbiter and all dependencies

set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing Orbiter v0.1.0-barebones${NC}"
echo ""

# Detect OS and package manager
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            echo "linux-apt"
        elif command -v yum &> /dev/null; then
            echo "linux-yum"
        elif command -v dnf &> /dev/null; then
            echo "linux-dnf"
        else
            echo "linux-unknown"
        fi
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

# Install a package based on OS
install_package() {
    local package="$1"
    local brew_name="${2:-$package}"
    local apt_name="${3:-$package}"

    echo -e "${BLUE}Installing $package...${NC}"

    case "$OS" in
        macos)
            if command -v brew &> /dev/null; then
                brew install "$brew_name" 2>/dev/null || echo "  (already installed or failed)"
            else
                echo -e "${YELLOW}⚠${NC} Homebrew not found. Install manually:"
                echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                return 1
            fi
            ;;
        linux-apt)
            if [ "$EUID" -ne 0 ]; then
                echo "  sudo apt-get install -y $apt_name"
                sudo apt-get update -qq && sudo apt-get install -y "$apt_name" 2>/dev/null || echo "  (already installed or failed)"
            else
                apt-get update -qq && apt-get install -y "$apt_name" 2>/dev/null || echo "  (already installed or failed)"
            fi
            ;;
        linux-yum|linux-dnf)
            local pkg_manager="yum"
            [ "$OS" = "linux-dnf" ] && pkg_manager="dnf"
            if [ "$EUID" -ne 0 ]; then
                echo "  sudo $pkg_manager install -y $apt_name"
                sudo $pkg_manager install -y "$apt_name" 2>/dev/null || echo "  (already installed or failed)"
            else
                $pkg_manager install -y "$apt_name" 2>/dev/null || echo "  (already installed or failed)"
            fi
            ;;
        *)
            echo -e "${YELLOW}⚠${NC} Unknown OS. Please install $package manually"
            return 1
            ;;
    esac
}

# Check and install dependencies
echo -e "${BLUE}Checking dependencies...${NC}"
echo ""

# jq (required)
if ! command -v jq &> /dev/null; then
    install_package "jq" "jq" "jq"
else
    echo -e "${GREEN}✓${NC} jq is installed"
fi

# rsync (usually pre-installed)
if ! command -v rsync &> /dev/null; then
    install_package "rsync" "rsync" "rsync"
else
    echo -e "${GREEN}✓${NC} rsync is installed"
fi

# python3 (required for server mode)
if ! command -v python3 &> /dev/null; then
    install_package "python3" "python3" "python3"
else
    echo -e "${GREEN}✓${NC} python3 is installed"
fi

# ngrok (optional, for --public mode)
if ! command -v ngrok &> /dev/null; then
    echo ""
    echo -e "${YELLOW}⚠${NC} ngrok not installed (optional, needed for 'orb serve --public')"
    echo -e "${BLUE}Install later if needed:${NC}"
    case "$OS" in
        macos)
            echo "  brew install ngrok"
            ;;
        linux-*)
            echo "  snap install ngrok"
            echo "  # or download from: https://ngrok.com/download"
            ;;
        *)
            echo "  https://ngrok.com/download"
            ;;
    esac
else
    echo -e "${GREEN}✓${NC} ngrok is installed"
fi

echo ""
echo -e "${BLUE}Installing orbiter...${NC}"

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Copy orb to install directory
cp "$SCRIPT_DIR/orb" "$INSTALL_DIR/orb"
chmod +x "$INSTALL_DIR/orb"

echo -e "${GREEN}✓${NC} Installed orbiter to $INSTALL_DIR/orb"

# Check if directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo -e "${YELLOW}⚠${NC} $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add this to your ~/.zshrc or ~/.bashrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""

    # Try to add to PATH automatically
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$HOME/.zshrc"; then
            echo ""
            read -p "Add to ~/.zshrc automatically? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
                echo -e "${GREEN}✓${NC} Added to ~/.zshrc (restart terminal or run: source ~/.zshrc)"
            fi
        fi
    fi
else
    echo -e "${GREEN}✓${NC} $INSTALL_DIR is already in your PATH"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${BLUE}Quick start:${NC}"
echo "  orb config set-sync-path ~/Dropbox/orbiter-sync   # or use 'orb serve --public'"
echo "  orb config add spoq-web-apis"
echo "  orb push"
echo ""
