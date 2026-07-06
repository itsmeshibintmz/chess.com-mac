#!/bin/bash

# Exit on error
set -e

# Change directory to the repository root
cd "$(dirname "$0")"

echo "🏗️ Building Chess.com for macOS (Release build)..."
# Build a clean Release binary into a local build folder
xcodebuild -scheme ChessMac -configuration Release -derivedDataPath ./build -destination 'platform=macOS' clean build > /dev/null

echo "📦 Packaging custom branded DMG..."
# Cleanup old DMG
rm -f ~/Desktop/Chess.com.dmg

# Create temp source directory for packaging
mkdir -p ./build/dmg_temp
cp -R "./build/Build/Products/Release/ChessMac.app" ./build/dmg_temp/
mv "./build/dmg_temp/ChessMac.app" "./build/dmg_temp/Chess.com.app"

# Build the custom styled DMG
create-dmg \
  --volname "Chess.com" \
  --volicon "./ChessMac/Resources/DmgVolumeIcon.icns" \
  --background "./ChessMac/Resources/dmg_background.jpg" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 90 \
  --icon "Chess.com.app" 150 200 \
  --app-drop-link 450 200 \
  --hide-extension "Chess.com.app" \
  ~/Desktop/Chess.com.dmg \
  ./build/dmg_temp/

echo "🏷️ Setting custom Desktop icon for the DMG file..."
# Apply the custom disk icon to the .dmg file itself
swift -e 'import Cocoa; let img = NSImage(contentsOfFile: "./ChessMac/Resources/DmgVolumeIcon.icns"); NSWorkspace.shared.setIcon(img, forFile: "/Users/shibin_tmz/Desktop/Chess.com.dmg", options: [])'

echo "🧹 Cleaning up build caches..."
rm -rf ./build

echo "✅ Branded DMG successfully generated on Desktop!"
