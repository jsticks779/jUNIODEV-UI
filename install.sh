#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# Big Logo
echo -e "${CYAN}"
echo "   ╔══════════════════════════════════════════════╗"
echo "   ║                                              ║"
echo "   ║     ${BOLD}JJJJJ U   U N   N IIIII OOOOO DDDD  ${CYAN}║"
echo "   ║       J   U   U NN  N   I   O   O D   D ${CYAN}║"
echo "   ║       J   U   U N N N   I   O   O D   D ${CYAN}║"
echo "   ║     J J  U   U N  NN   I   O   O D   D ${CYAN}║"
echo "   ║     JJJ   UUU  N   N IIIII OOOOO DDDD  ${CYAN}║"
echo "   ║                                              ║"
echo "   ║         ${BOLD}EEEEEE V   V  000    ${CYAN}║"
echo "   ║         E      V   V 0   0   ${CYAN}║"
echo "   ║         EEEE    V V  0   0   ${CYAN}║"
echo "   ║         E       V V  0   0   ${CYAN}║"
echo "   ║         EEEEEE   V    000    ${CYAN}║"
echo "   ║                                              ║"
echo "   ╚══════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║      jUNIODEV-UI INSTALLER v2.2.8           ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# Detect system info
echo -e "${YELLOW}[*]${NC} Detecting system information..."
ARCH=$(uname -m)
OS=$(uname -s)
echo -e "    ${GREEN}OS:${NC} $OS"
echo -e "    ${GREEN}Arch:${NC} $ARCH"

# Download AppImage
echo ""
echo -e "${YELLOW}[*]${NC} Downloading jUNIODEV-UI..."
mkdir -p ~/AppImages
APPIMAGE_PATH="$HOME/AppImages/jUNIODEV-UI.AppImage"

wget -q --show-progress "https://github.com/jsticks779/jUNIODEV-UI/releases/latest/download/jUNIODEV-UI-x86_64.AppImage" \
  -O "$APPIMAGE_PATH" 2>/dev/null || {
  echo -e "${RED}[!]${NC} Download failed. Trying fallback..."
  cp /tmp/jUNIODEV-UI.AppImage "$APPIMAGE_PATH" 2>/dev/null || {
    echo -e "${RED}[!]${NC} Could not download AppImage."
    echo -e "    Please download manually from:"
    echo -e "    ${BLUE}https://github.com/jsticks779/jUNIODEV-UI/releases${NC}"
    exit 1
  }
}

chmod +x "$APPIMAGE_PATH"

echo -e "    ${GREEN}✓${NC} AppImage saved to: ${BOLD}$APPIMAGE_PATH${NC}"

# Install app icon
echo ""
echo -e "${YELLOW}[*]${NC} Installing desktop icon..."
mkdir -p ~/.local/share/icons/hicolor/{512x512,256x256,128x128,96x96,64x64,48x48,32x32,24x24,16x16}/apps

# Create icon if wget fails
wget -q "https://github.com/jsticks779/jUNIODEV-UI/releases/latest/download/juniodev-ui-512.png" \
  -O ~/.local/share/icons/hicolor/512x512/apps/juniodev-ui.png 2>/dev/null || {
  # Create a simple icon using ImageMagick if available
  if command -v convert &>/dev/null; then
    convert -size 512x512 xc:'#0d1117' \
      -fill '#161b22' -stroke '#30363d' -strokewidth 2 \
      -draw 'roundrectangle 20,20 492,492 30,30' \
      -fill none -stroke '#58a6ff' -strokewidth 3 \
      -draw 'roundrectangle 40,40 472,472 25,25' \
      -font Courier-Bold -pointsize 320 -fill '#58a6ff' \
      -gravity center -annotate +0+10 'J' \
      -font Courier-Bold -pointsize 32 -fill '#8b949e' \
      -gravity south -annotate +0+35 'jUNIODEV-UI' \
      ~/.local/share/icons/hicolor/512x512/apps/juniodev-ui.png 2>/dev/null
  fi
}

gtk-update-icon-cache ~/.local/share/icons/hicolor/ 2>/dev/null || true

# Create desktop entry
echo ""
echo -e "${YELLOW}[*]${NC} Creating desktop entry..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/juniodev-ui.desktop << 'DESKTOP'
[Desktop Entry]
Name=jUNIODEV-UI
Exec=$HOME/AppImages/jUNIODEV-UI.AppImage --no-sandbox %U
Terminal=false
Type=Application
Icon=juniodev-ui
StartupWMClass=jUNIODEV-UI
Comment=jUNIODEV-UI Sci-Fi Terminal Interface
Categories=System;TerminalEmulator;
DESKTOP

chmod +x ~/.local/share/applications/juniodev-ui.desktop

# Create jdev command
echo ""
echo -e "${YELLOW}[*]${NC} Creating 'jdev' command..."
JDEV_SCRIPT="$HOME/.local/bin/jdev"
mkdir -p "$HOME/.local/bin"
cat > "$JDEV_SCRIPT" << 'JDEV'
#!/bin/bash
exec "$HOME/AppImages/jUNIODEV-UI.AppImage" --no-sandbox "$@"
JDEV
chmod +x "$JDEV_SCRIPT"

# Add to PATH if not already
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
    echo -e "    ${YELLOW}ℹ${NC} Added ~/.local/bin to PATH (restart shell or run: source ~/.bashrc)"
fi

echo -e "    ${GREEN}✓${NC} Run with: ${BOLD}jdev${NC}"

# Detect user's shell
USER_SHELL=$(basename "$SHELL" 2>/dev/null || echo "bash")
echo ""
echo -e "${YELLOW}[*]${NC} Detected shell: ${BOLD}$USER_SHELL${NC}"

# Success message
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           INSTALLATION COMPLETE!            ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}jUNIODEV-UI${NC} has been installed to your system."
echo ""
echo -e "  ${GREEN}▶${NC} Launch from your ${BOLD}Applications menu${NC} (search 'jUNIODEV')"
echo -e "  ${GREEN}▶${NC} Run in terminal: ${BOLD}jdev${NC}"
echo -e "  ${GREEN}▶${NC} AppImage location: ${BOLD}$APPIMAGE_PATH${NC}"
echo ""
echo -e "  ${YELLOW}💡${NC} The app will use your shell (${BOLD}$USER_SHELL${NC}) automatically."
echo -e "  ${YELLOW}💡${NC} It opens in fullscreen with the ${BOLD}juniodev${NC} theme."
echo ""
echo -e "  ${CYAN}Enjoy your futuristic terminal! 🚀${NC}"
echo ""

