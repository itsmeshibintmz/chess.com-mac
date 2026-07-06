// MARK: - ChessMacApp.swift
// Main entry point for the Chess.com macOS web wrapper application.

import SwiftUI

@main
struct ChessMacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("appTheme") private var appTheme = "system"

    var body: some Scene {
        WindowGroup {
            ChessWebViewContainer()
                .frame(minWidth: 1024, minHeight: 680)
                .preferredColorScheme(appTheme == "system" ? nil : (appTheme == "dark" ? .dark : .light))
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            // Remove New Window command
            CommandGroup(replacing: .newItem) {}
            
            // Add Check for Updates option under application info menu
            CommandGroup(after: .appInfo) {
                Button("Check for Updates...") {
                    UpdateManager.shared.checkForUpdates(manual: true)
                }
            }
        }

        // Native Preferences Window (accessed via ⌘,)
        Settings {
            SettingsView()
                .preferredColorScheme(appTheme == "system" ? nil : (appTheme == "dark" ? .dark : .light))
        }
    }
}
