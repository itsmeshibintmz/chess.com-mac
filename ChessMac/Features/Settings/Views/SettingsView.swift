// MARK: - SettingsView.swift
// Preferences panel for controlling Chess.com macOS app settings.

import SwiftUI

struct SettingsView: View {
    @AppStorage("blockAds") private var blockAds = true
    @AppStorage("defaultLandingPage") private var defaultLandingPage = "https://www.chess.com"
    
    // Shortcuts toggles
    @AppStorage("showPlayShortcut") private var showPlayShortcut = true
    @AppStorage("showPuzzlesShortcut") private var showPuzzlesShortcut = true
    @AppStorage("showComputerShortcut") private var showComputerShortcut = true
    @AppStorage("showLessonsShortcut") private var showLessonsShortcut = true

    @State private var activeTab: SettingsTab = .general

    enum SettingsTab: String, CaseIterable, Identifiable {
        case general = "General"
        case navigation = "Shortcuts"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .general: return "gearshape.fill"
            case .navigation: return "dock.rectangle"
            }
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            // Sidebar Navigation
            VStack(spacing: 6) {
                Spacer().frame(height: 32)

                // Navigation Items
                ForEach(SettingsTab.allCases) { tab in
                    Button(action: { activeTab = tab }) {
                        HStack(spacing: 10) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 13))
                                .foregroundStyle(activeTab == tab ? .white : .gray)
                                .frame(width: 16)
                            Text(tab.rawValue)
                                .font(.system(size: 13, weight: activeTab == tab ? .bold : .regular))
                                .foregroundStyle(activeTab == tab ? .white : .gray)
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(activeTab == tab ? Color.chessGreen : Color.clear)
                        )
                    }
                    .buttonStyle(.plain)
                    .hoverLift(scale: 1.02)
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(width: 160)
            .background(.ultraThinMaterial)
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 1),
                alignment: .trailing
            )

            // Details Panel
            VStack(alignment: .leading, spacing: 0) {
                switch activeTab {
                case .general:
                    generalPane
                case .navigation:
                    navigationPane
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.chessDarkBG.opacity(0.65).background(.thinMaterial))
        }
        .frame(width: 580, height: 360)
        .preferredColorScheme(.dark)
        .navigationTitle("Preferences")
    }

    private var generalPane: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text("General Preferences")
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(.white)
                Text("Customize your app behavior and browsing experiences.")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
            }
            
            VStack(spacing: 10) {
                // Ad Blocker Row
                generalToggleRow(
                    isOn: $blockAds,
                    title: "Block Ads & Commercial Banners",
                    description: "Filters out advertisement containers to keep games clutter-free.",
                    icon: "shield.fill",
                    iconColor: .orange
                )
                
                Divider().background(Color.white.opacity(0.06))

                // Default Landing Page Selector
                HStack(spacing: 12) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.chessGreen)
                        .frame(width: 22, height: 22)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Default Landing Page")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                        Text("Choose which section loads when launching the app.")
                            .font(.system(size: 11))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Picker("", selection: $defaultLandingPage) {
                        Text("Dashboard").tag("https://www.chess.com")
                        Text("Play Online").tag("https://www.chess.com/play/online")
                        Text("Puzzles").tag("https://www.chess.com/puzzles")
                        Text("vs. Computer").tag("https://www.chess.com/play/computer")
                        Text("Lessons").tag("https://www.chess.com/lessons")
                    }
                    .pickerStyle(.menu)
                    .tint(Color.chessGreen)
                    .frame(width: 140)
                }
            }
            .padding(14)
            .background(Color.white.opacity(0.02))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )

            Spacer()
        }
        .padding(20)
    }

    private var navigationPane: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Control Pill Shortcuts")
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(.white)
                Text("Select which quick actions appear in the floating controls bar at the bottom.")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
            }
            
            VStack(spacing: 10) {
                generalToggleRow(
                    isOn: $showPlayShortcut,
                    title: "Play Online Shortcut",
                    description: "Enables play online sword/controller shortcut icon.",
                    icon: "gamecontroller.fill",
                    iconColor: Color.chessGreen
                )
                
                Divider().background(Color.white.opacity(0.06))

                generalToggleRow(
                    isOn: $showPuzzlesShortcut,
                    title: "Puzzles Shortcut",
                    description: "Enables quick navigation to chess puzzles.",
                    icon: "puzzlepiece.fill",
                    iconColor: Color.chessGreen
                )

                Divider().background(Color.white.opacity(0.06))

                generalToggleRow(
                    isOn: $showComputerShortcut,
                    title: "vs. Computer Shortcut",
                    description: "Enables link to start computer matches.",
                    icon: "cpu",
                    iconColor: Color.chessGreen
                )

                Divider().background(Color.white.opacity(0.06))

                generalToggleRow(
                    isOn: $showLessonsShortcut,
                    title: "Lessons Shortcut",
                    description: "Enables link to browse chess lessons.",
                    icon: "graduationcap.fill",
                    iconColor: Color.chessGreen
                )
            }
            .padding(14)
            .background(Color.white.opacity(0.02))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )

            Spacer()
        }
        .padding(20)
    }

    private func generalToggleRow(isOn: Binding<Bool>, title: String, description: String, icon: String, iconColor: Color = .chessGreen, hasStroke: Bool = false) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(iconColor)
                .frame(width: 22, height: 22)
                .background(Color.white.opacity(0.03))
                .cornerRadius(6)
                .overlay(
                    Group {
                        if hasStroke {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        }
                    }
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                Text(description)
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .toggleStyle(.switch)
                .tint(Color.chessGreen)
        }
    }
}
