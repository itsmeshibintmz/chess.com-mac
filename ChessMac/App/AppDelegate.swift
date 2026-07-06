// MARK: - AppDelegate.swift
// NSApplicationDelegate: Handles global appearance and application lifecycle.

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupAppearance()
        
        // Listen to theme changes to update NSApp.appearance dynamically
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeChanged),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
        updateAppAppearance()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Close app when window is closed for standard desktop app behavior
        true
    }

    @objc private func themeChanged() {
        updateAppAppearance()
    }

    private func updateAppAppearance() {
        let theme = UserDefaults.standard.string(forKey: "appTheme") ?? "system"
        DispatchQueue.main.async {
            if theme == "light" {
                NSApp.appearance = NSAppearance(named: .aqua)
            } else if theme == "dark" {
                NSApp.appearance = NSAppearance(named: .darkAqua)
            } else {
                NSApp.appearance = nil // follows system
            }
        }
    }

    private func setupAppearance() {
        NSWindow.allowsAutomaticWindowTabbing = false
    }
}
