# Chess.com macOS Web App

An unofficial, native-feel macOS desktop application wrapper for **Chess.com**. Built using **SwiftUI** and **AppKit**, this wrapper features custom theme accents, a floating navigation pill, an integrated ad-blocker, and deep macOS integration.

---

## 📸 Screenshots

| Main Application View | Preferences Panel (⌘,) | Custom DMG Installer |
| :---: | :---: | :---: |
| ![Chess.com Main View](images/app_screenshot.png) | ![Preferences Panel](images/settings_screenshot.png) | ![DMG Installer](images/dmg_screenshot.png) |

---

## ✨ Features

*   **Apple Liquid Glass Design Language**: floating capsule pill controller, continuous corner radius clipping (`.smoothCorners`), specular reflections, and responsive hover-lift transitions (`.hoverLift`).
*   **Floating Control Pill Dock**: A beautiful capsule bar that floats at the bottom-center of the window. Automatically slides in when the mouse moves and hides when inactive. Contains:
    *   *System Controls*: Back, Forward, Reload, Home.
    *   *App Shortcuts*: Play Online, Puzzles, vs. Computer, and Lessons.
    *   *Quick Toggle*: Shield icon to turn the Ad-Blocker on/off instantly.
*   **Built-in Ad-Blocker**: Injects custom stylesheets to filter out advertisements, banners, and sidebar commercial slots, keeping your game board completely clean.
*   **Native Preferences Panel (⌘,)**: Fully configurable macOS settings window allowing you to customize:
    *   *Default landing page* (Dashboard, Play, Puzzles, Computer, or Lessons).
    *   *Visible Shortcuts* in the bottom floating capsule bar.
    *   *Ad-Blocker* toggle.
*   **Deep macOS Integration**:
    *   **Traffic Lights Alignment**: Left-hand navigation shifted down by `36px` to prevent overlapping macOS window controls (close/minimize/zoom).
    *   **Draggable Header**: Double-click titlebar zoom and standard window dragging.
    *   **Safari User-Agent Spoofing**: Fully compatible with Google, Apple, and Facebook OAuth login flows.
    *   **Elegant Scrollbars**: Customized scrollbars that look great in both dark and light modes.

---

## 🛠️ Build & Installation

### Build Requirements
*   macOS 13.0 or higher
*   Xcode 15.0 or higher
*   `create-dmg` (optional, for installer packaging)

### Compiling and Running
1. Clone the repository:
   ```bash
   git clone https://github.com/itsmeshibintmz/chess.com-mac.git
   cd chess.com-mac
   ```
2. Open `ChessMac.xcodeproj` in Xcode and click **Run**.

### Generating a Branded DMG Installer
We provide a helper packaging script:
```bash
./build_dmg.sh
```
This script compiles a clean Release build and outputs a fully customized, branded disk image installer **`Chess.com.dmg`** directly into your **Downloads** folder.

---

## 🤝 Disclaimer

This project is a personal utility. It is not affiliated, associated, authorized, endorsed by, or in any way officially connected with Chess.com.
