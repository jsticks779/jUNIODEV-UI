# jUNIODEV-UI

A futuristic terminal interface with real-time system monitoring, inspired by sci-fi UIs.

![jUNIODEV-UI](screenshot.png)

## One-Command Install

```bash
curl -sSL https://raw.githubusercontent.com/jsticks779/jUNIODEV-UI/main/install.sh | bash
```

Or download the AppImage manually from the [Releases](https://github.com/jsticks779/jUNIODEV-UI/releases) page.

## Usage

After installation:
- Run `jdev` from terminal
- Or launch from your applications menu (search "jUNIODEV")
- Or run the AppImage directly: `~/AppImages/jUNIODEV-UI.AppImage --no-sandbox`

## Features

- Real-time terminal emulator
- System monitoring (CPU, RAM, network, disks)
- Interactive process viewer
- Network globe visualization
- On-screen keyboard
- Custom themes
- Audio sound effects

## Requirements

- Linux x86_64
- FUSE (for AppImage) - usually pre-installed
- A shell (bash, zsh, fish, etc.)

## Build from Source

```bash
git clone https://github.com/jsticks779/jUNIODEV-UI.git
cd jUNIODEV-UI
npm install
npm start
```

## Credits

Based on [eDEX-UI](https://github.com/GitSquared/edex-ui) by GitSquared.

## License

MIT
