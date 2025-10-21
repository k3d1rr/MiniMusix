# MiniMusix - Native macOS Miniplayer

A powerful, native macOS miniplayer that monitors system media and presents a sleek, compact interface with deep platform integration.

![MiniMusix Screenshot](https://via.placeholder.com/800x400/1db954/ffffff?text=MiniMusix+Screenshot)

## ✨ Features

- 🎵 **System Media Monitoring** - Hooks into macOS MediaRemote framework for universal media detection
- 🌈 **Dynamic Theming** - Extracts colors from album artwork for cohesive theming
- 📝 **Floating Lyrics Viewer** - Right-side floating panel with scrollable lyrics
- 🎛️ **Universal Media Support** - Compatible with Spotify, Apple Music, browsers, VLC, and more
- ✨ **Glass Morphism Design** - Beautiful backdrop blur with translucent surfaces
- 🚀 **Native Integration** - Deep macOS integration with menu bar icon and system permissions
- 🌐 **Web Distribution** - Sideloaded installation with GitHub-based updates

## 🚀 Installation

### Option 1: Download DMG (Recommended)
1. Go to the [latest release](https://github.com/k3d1rr/MiniMusix/releases/latest)
2. Download `MiniMusix-Release.dmg` from the assets
3. Open the DMG file
4. Drag `MiniMusix.app` to your Applications folder
5. Right-click the app → **Open** (to bypass Gatekeeper)
6. Grant Accessibility permissions in **System Settings > Privacy & Security > Accessibility**

### Option 2: Download .app Bundle
1. Go to the [latest release](https://github.com/k3d1rr/MiniMusix/releases/latest)
2. Download `MiniMusix.app.zip` from the assets
3. Unzip the file to get `MiniMusix.app`
4. Drag `MiniMusix.app` to your Applications folder
5. Right-click the app → **Open** (to bypass Gatekeeper)
6. Grant Accessibility permissions in **System Settings > Privacy & Security > Accessibility**

### Option 3: Build from Source
```bash
# Clone the repository
git clone https://github.com/k3d1rr/MiniMusix.git
cd MiniMusix

# Open in Xcode
open MiniMusix/MiniMusix.xcodeproj

# Build and run
# Make sure to codesign for development
```

## 🔧 Setup & Permissions

MiniMusix requires Accessibility permissions to control media playback:

1. Open **System Settings**
2. Go to **Privacy & Security > Accessibility**
3. Enable **MiniMusix** in the list
4. Restart MiniMusix if needed

## 🎮 Usage

1. **Menu Bar Icon** - Click the waveform icon in your menu bar to open the miniplayer
2. **Media Detection** - Play music in any supported app (Spotify, Apple Music, etc.)
3. **Miniplayer** - The floating player will appear when media is detected
4. **Lyrics** - Hover over the right edge of your screen for the lyrics panel
5. **Controls** - Use playback controls or media keys to control playback

## 🏗️ Architecture

### Core Components

- **EnhancedMediaDetector** - System-level media monitoring using MediaRemote framework
- **MiniPlayerView** - SwiftUI miniplayer with glass morphism design
- **LyricsViewer** - Floating lyrics panel with smooth animations
- **StatusBarController** - Native menu bar integration
- **ColorThemeManager** - Dynamic theming from album artwork
- **MediaMonitorModel** - State management bridging system detection and UI

### Technology Stack

- **Objective-C** - Core system integration and media detection
- **SwiftUI** - Modern UI framework with declarative syntax
- **MediaRemote** - macOS framework for system media control
- **AppKit** - Native macOS UI components

## 🎨 Design

- **Glass Morphism** - Backdrop blur with translucent surfaces
- **Dynamic Colors** - Theme adaptation based on album artwork
- **Smooth Animations** - Spring-based transitions and hover effects
- **Native Feel** - Deep macOS integration with system aesthetics

## 🌍 Distribution

MiniMusix uses a web-based distribution model:

- **GitHub Releases** - Automated DMG creation and notarization
- **Sideloaded Installation** - Community-friendly distribution
- **Self-Updating** - Users can check for updates through the help menu

## 🤝 Contributing

We welcome contributions! Here's how to get involved:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
# Install dependencies
brew install create-dmg

# For notarization (optional)
# Add your Apple ID and team ID to secrets
```

## 📋 Requirements

- **macOS 12.0** or later
- **Accessibility permissions** for media control
- **Internet connection** for lyrics (optional)

## 🐛 Troubleshooting

### Common Issues

**MiniMusix doesn't detect media:**
- Ensure Accessibility permissions are granted
- Restart MiniMusix after granting permissions
- Check that your media app is playing

**Miniplayer doesn't appear:**
- Click the waveform icon in the menu bar
- Check if media is currently playing
- Try restarting the app

**Lyrics don't show:**
- Hover over the right edge of your screen
- Lyrics availability depends on the track

### Getting Help

- [Report Issues](https://github.com/username/minimusix/issues)
- [Community Discussions](https://github.com/username/minimusix/discussions)
- Check the [Wiki](https://github.com/username/minimusix/wiki) for detailed guides

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with ❤️ for the macOS community
- Inspired by modern music player designs
- Powered by Apple's MediaRemote framework

## 📞 Support

For support and questions:
- Create an [issue](https://github.com/username/minimusix/issues) on GitHub
- Join the [discussions](https://github.com/username/minimusix/discussions)
- Check existing [documentation](https://github.com/username/minimusix/wiki)

---

**Made with ❤️ for macOS users who love great music experiences**
