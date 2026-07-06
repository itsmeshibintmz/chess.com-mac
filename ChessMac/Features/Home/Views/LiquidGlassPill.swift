// MARK: - LiquidGlassPill.swift
// A capsule-shaped controls overlay dock designed to float at the bottom center of the window, styled with Apple Liquid Glass.

import SwiftUI

struct LiquidGlassPill: View {
    let canGoBack: Bool
    let canGoForward: Bool
    let goBackAction: () -> Void
    let goForwardAction: () -> Void
    let reloadAction: () -> Void
    let homeAction: () -> Void
    
    // Chess.com specific quick actions
    let playAction: () -> Void
    let puzzlesAction: () -> Void
    let computerAction: () -> Void
    let lessonsAction: () -> Void

    @Binding var isHoveredSelf: Bool
    @AppStorage("blockAds") private var blockAds = true

    // Shortcuts visibility settings
    @AppStorage("showPlayShortcut") private var showPlayShortcut = true
    @AppStorage("showPuzzlesShortcut") private var showPuzzlesShortcut = true
    @AppStorage("showComputerShortcut") private var showComputerShortcut = true
    @AppStorage("showLessonsShortcut") private var showLessonsShortcut = true

    // Hover state specifically for the SettingsLink button
    @State private var isSettingsHovered = false

    var body: some View {
        HStack(spacing: 16) {
            // 1. Back button
            PillButton(icon: "chevron.left", isEnabled: canGoBack, activeColor: Color.chessGreen) {
                goBackAction()
            }

            // 2. Forward button
            PillButton(icon: "chevron.right", isEnabled: canGoForward, activeColor: Color.chessGreen) {
                goForwardAction()
            }

            Divider()
                .frame(height: 18)
                .background(Color.white.opacity(0.12))

            // 3. Reload button
            PillButton(icon: "arrow.clockwise", isEnabled: true, activeColor: Color.chessGreen) {
                reloadAction()
            }

            // 4. Home button
            PillButton(icon: "house.fill", isEnabled: true, activeColor: Color.chessGreen) {
                homeAction()
            }

            if showPlayShortcut || showPuzzlesShortcut || showComputerShortcut || showLessonsShortcut {
                Divider()
                    .frame(height: 18)
                    .background(Color.white.opacity(0.12))

                // 5. Play Online
                if showPlayShortcut {
                    PillButton(icon: "gamecontroller.fill", isEnabled: true, activeColor: Color.chessGreen) {
                        playAction()
                    }
                }

                // 6. Puzzles
                if showPuzzlesShortcut {
                    PillButton(icon: "puzzlepiece.fill", isEnabled: true, activeColor: Color.chessGreen) {
                        puzzlesAction()
                    }
                }

                // 7. Play vs Computer
                if showComputerShortcut {
                    PillButton(icon: "cpu", isEnabled: true, activeColor: Color.chessGreen) {
                        computerAction()
                    }
                }

                // 8. Lessons
                if showLessonsShortcut {
                    PillButton(icon: "graduationcap.fill", isEnabled: true, activeColor: Color.chessGreen) {
                        lessonsAction()
                    }
                }

                Divider()
                    .frame(height: 18)
                    .background(Color.white.opacity(0.12))
            }

            // 9. Ad-Blocker Toggle
            PillButton(
                icon: blockAds ? "shield.fill" : "shield",
                isEnabled: true,
                activeColor: .orange,
                isSelected: blockAds
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    blockAds.toggle()
                }
            }

            // 10. Settings gear button
            if #available(macOS 14.0, *) {
                // Native SettingsLink for macOS 14+ to prevent Xcode deprecation warnings
                SettingsLink {
                    settingsLabel
                }
                .buttonStyle(.plain)
                .hoverLift(scale: 1.1, shadowRadius: 10)
                .focusable(false)
                .onHover { hovering in
                    isSettingsHovered = hovering
                }
            } else {
                // Fallback AppKit selector for macOS 13
                Button(action: {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    
                    // Force the settings window to bring itself key and front
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let settingsWindow = NSApp.windows.first(where: { $0.title == "Settings" || $0.title == "Preferences" }) {
                            settingsWindow.makeKeyAndOrderFront(nil)
                            NSApp.activate(ignoringOtherApps: true)
                        }
                    }
                }) {
                    settingsLabel
                }
                .buttonStyle(.plain)
                .hoverLift(scale: 1.1, shadowRadius: 10)
                .focusable(false)
                .onHover { hovering in
                    isSettingsHovered = hovering
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 8)
        .liquidGlass(cornerRadius: 24) // Apply custom specular gradient highlight & 3D borders
        .onHover { hovering in
            isHoveredSelf = hovering
        }
    }

    // Shared visual label for settings button
    private var settingsLabel: some View {
        Image(systemName: "gearshape.fill")
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(isSettingsHovered ? Color.chessGreen : .white.opacity(0.75))
            .frame(width: 32, height: 32)
            .background {
                if isSettingsHovered {
                    Circle()
                        .fill(Color.chessGreen.opacity(0.15))
                        .shadow(color: Color.chessGreen.opacity(0.3), radius: 6)
                }
            }
    }
}

// MARK: - Pill Button Component
struct PillButton: View {
    let icon: String
    let isEnabled: Bool
    let activeColor: Color
    var isSelected: Bool = false
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(
                    isSelected ? activeColor :
                    (isEnabled ? (isHovered ? activeColor : .white.opacity(0.75)) : .white.opacity(0.2))
                )
                .frame(width: 32, height: 32)
                .background {
                    if isEnabled && isHovered {
                        Circle()
                            .fill(activeColor.opacity(0.15))
                            .shadow(color: activeColor.opacity(0.3), radius: 6)
                    } else if isSelected {
                        Circle()
                            .fill(activeColor.opacity(0.08))
                    }
                }
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
        .focusable(false)
        .hoverLift(scale: 1.1, shadowRadius: 10) // Custom design-system lift/hover effect
        .onHover { hovering in
            if isEnabled {
                isHovered = hovering
            }
        }
    }
}
