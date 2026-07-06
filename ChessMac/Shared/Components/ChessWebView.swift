// MARK: - ChessWebView.swift
// Native WKWebView wrapper for macOS featuring Safari User-Agent spoofing, ad-blocking, and layout adjustments.

import SwiftUI
import WebKit

struct ChessWebView: NSViewRepresentable {
    let url: URL
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var isLoading: Bool
    let commandCoordinator: CommandCoordinator

    // Preferences properties passed from container
    let blockAds: Bool
    let defaultLandingPage: String
    let appTheme: String

    class CommandCoordinator {
        var goBackAction: (() -> Void)?
        var goForwardAction: (() -> Void)?
        var reloadAction: (() -> Void)?
        var loadHomeAction: (() -> Void)?
        var loadPlayAction: (() -> Void)?
        var loadPuzzlesAction: (() -> Void)?
        var loadComputerAction: (() -> Void)?
        var loadLessonsAction: (() -> Void)?
    }

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }

    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.default()

        // 1. Initialize settings properties in JS at document start
        let settingsSource = "window.chessMacSettings = { blockAds: \(blockAds) };"
        let settingsScript = WKUserScript(source: settingsSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(settingsScript)

        // 2. Inject custom CSS to align elements under window controls and style scrollbars
        let cssSource = """
        (function() {
            var style = document.createElement('style');
            style.id = 'chessmac-custom-style';
            style.innerHTML = `
                /* Shift vertical sidebar navigation down to prevent overlapping window traffic lights */
                #navigation, 
                .navigation, 
                .nav-menu, 
                .nav-menu-area, 
                .nav-container, 
                .nav-sidebar, 
                nav, 
                #sb, 
                .sb {
                    margin-top: 36px !important;
                }

                header, 
                .header, 
                #header, 
                .nav-header {
                    padding-top: 36px !important;
                }

                /* Custom elegant, ultra-thin scrollbars visible in both dark & light modes */
                ::-webkit-scrollbar {
                    width: 8px !important;
                    height: 8px !important;
                }
                ::-webkit-scrollbar-track {
                    background: transparent !important;
                }
                ::-webkit-scrollbar-thumb {
                    background: rgba(128, 128, 128, 0.3) !important;
                    border-radius: 4px !important;
                    border: 2px solid transparent !important;
                }
                ::-webkit-scrollbar-thumb:hover {
                    background: rgba(128, 128, 128, 0.5) !important;
                }
            `;
            document.head.appendChild(style);

            // Ad blocking stylesheets
            function updateAdBlocking() {
                var adStyle = document.getElementById('chessmac-adblock-style');
                var blockEnabled = window.chessMacSettings && window.chessMacSettings.blockAds;
                
                if (blockEnabled) {
                    if (!adStyle) {
                        adStyle = document.createElement('style');
                        adStyle.id = 'chessmac-adblock-style';
                        adStyle.innerHTML = `
                            div[id^="ad-"], 
                            div[class*="ad-"], 
                            .ads-container, 
                            .ad-layout-sidebar, 
                            .sidebar-ads, 
                            iframe[id^="google_ads"], 
                            .chess-ad, 
                            #ad-banner, 
                            .ads-anchor, 
                            .ad-slot, 
                            .ads-wrapper,
                            #ad-sidebar,
                            .commercial-ad {
                                display: none !important;
                                width: 0 !important;
                                height: 0 !important;
                                visibility: hidden !important;
                                opacity: 0 !important;
                                pointer-events: none !important;
                            }
                        `;
                        document.head.appendChild(adStyle);
                    }
                } else {
                    if (adStyle) adStyle.remove();
                }
            }

            window.updateAppPreferences = updateAdBlocking;
            setTimeout(updateAdBlocking, 1000);
        })();
        """
        let cssScript = WKUserScript(source: cssSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(cssScript)

        // 3. Register script message handler
        configuration.userContentController.add(context.coordinator, name: "chessMac")

        // Enable developer tools in debug mode
        #if DEBUG
        configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        #endif
        configuration.preferences.setValue(true, forKey: "fullScreenEnabled")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true

        // Force desktop Safari User-Agent to avoid mobile redirection and enable hardware features
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15"

        // Wire up control bar actions
        commandCoordinator.goBackAction = { [weak webView] in
            if webView?.canGoBack == true { webView?.goBack() }
        }
        commandCoordinator.goForwardAction = { [weak webView] in
            if webView?.canGoForward == true { webView?.goForward() }
        }
        commandCoordinator.reloadAction = { [weak webView] in
            webView?.reload()
        }
        commandCoordinator.loadHomeAction = { [weak webView, weak coordinator = context.coordinator] in
            guard let parent = coordinator?.parent else { return }
            let request = URLRequest(url: URL(string: parent.defaultLandingPage) ?? URL(string: "https://www.chess.com")!)
            webView?.load(request)
        }
        commandCoordinator.loadPlayAction = { [weak webView] in
            let request = URLRequest(url: URL(string: "https://www.chess.com/play/online")!)
            webView?.load(request)
        }
        commandCoordinator.loadPuzzlesAction = { [weak webView] in
            let request = URLRequest(url: URL(string: "https://www.chess.com/puzzles")!)
            webView?.load(request)
        }
        commandCoordinator.loadComputerAction = { [weak webView] in
            let request = URLRequest(url: URL(string: "https://www.chess.com/play/computer")!)
            webView?.load(request)
        }
        commandCoordinator.loadLessonsAction = { [weak webView] in
            let request = URLRequest(url: URL(string: "https://www.chess.com/lessons")!)
            webView?.load(request)
        }

        // Load primary URL
        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        context.coordinator.parent = self
        
        // 1. Force the appearance of the webview to match light/dark settings
        if appTheme == "light" {
            nsView.appearance = NSAppearance(named: .aqua)
        } else if appTheme == "dark" {
            nsView.appearance = NSAppearance(named: .darkAqua)
        } else {
            nsView.appearance = nil // follows system
        }

        // 2. Sync Swift settings changes to Javascript and handle Pure Black & Light Theme overrides
        let js = """
        window.chessMacSettings = {
            blockAds: \(blockAds)
        };
        if (typeof window.updateAppPreferences === 'function') {
            window.updateAppPreferences();
        }
        
        (function() {
            // Force Chess.com HTML classes to match theme choice (vital for single-page navigations)
            function forceThemeClasses() {
                var theme = "\(appTheme)";
                var html = document.documentElement;
                var body = document.body;
                if (!html) return;
                
                if (theme === "light") {
                    html.classList.remove("dark-mode", "theme-dark", "dark");
                    html.classList.add("light-mode", "theme-light", "light");
                    html.style.colorScheme = "light";
                    if (body) {
                        body.classList.remove("dark-mode", "theme-dark", "dark");
                        body.classList.add("light-mode", "theme-light", "light");
                        body.style.colorScheme = "light";
                    }
                } else if (theme === "dark") {
                    html.classList.remove("light-mode", "theme-light", "light");
                    html.classList.add("dark-mode", "theme-dark", "dark");
                    html.style.colorScheme = "dark";
                    if (body) {
                        body.classList.remove("light-mode", "theme-light", "light");
                        body.classList.add("dark-mode", "theme-dark", "dark");
                        body.style.colorScheme = "dark";
                    }
                } else {
                    // System theme: Clear manual overrides and let system prefers-color-scheme rule
                    html.style.colorScheme = "";
                    if (body) body.style.colorScheme = "";
                }
            }
            forceThemeClasses();
            
            // Run periodically to catch SPA dynamic elements
            if (!window.chessThemeInterval) {
                window.chessThemeInterval = setInterval(forceThemeClasses, 1000);
            } else {
                // Ensure the interval function is updated with latest theme variable
                clearInterval(window.chessThemeInterval);
                window.chessThemeInterval = setInterval(forceThemeClasses, 1000);
            }
            
            // Manage AMOLED Pure Black styling stylesheet
            var style = document.getElementById('chessmac-pureblack-style');
            var pureBlackEnabled = \(appTheme == "dark");
            if (pureBlackEnabled) {
                if (!style) {
                    style = document.createElement('style');
                    style.id = 'chessmac-pureblack-style';
                    style.innerHTML = `
                        body, 
                        #navigation, 
                        .navigation, 
                        .nav-menu, 
                        .nav-container, 
                        #sb, 
                        .sb, 
                        .layout-container, 
                        #layout-container, 
                        .game-layout-sidebar, 
                        .board-layout-sidebar, 
                        .main, 
                        #main, 
                        .main-layout, 
                        .page-layout, 
                        .board-layout-component, 
                        .tab-container {
                            background-color: #000000 !important;
                            background: #000000 !important;
                        }
                    `;
                    document.head.appendChild(style);
                }
            } else {
                if (style) style.remove();
            }
        })();
        """
        nsView.evaluateJavaScript(js, completionHandler: nil)
    }

    static func dismantleNSView(_ nsView: WKWebView, coordinator: WebViewCoordinator) {
        nsView.configuration.userContentController.removeScriptMessageHandler(forName: "chessMac")
    }

    // MARK: - WKWebView Coordinator
    class WebViewCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        var parent: ChessWebView

        init(_ parent: ChessWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            
            // Only restrict page navigation inside the main frame
            if navigationAction.targetFrame?.isMainFrame == true {
                let host = url.host?.lowercased() ?? ""
                let isAllowed = host.hasSuffix("chess.com") ||
                                host.hasSuffix("google.com") ||
                                host.hasSuffix("youtube.com") ||
                                host.hasSuffix("googleusercontent.com") ||
                                host.hasSuffix("appleid.apple.com") ||
                                host.hasSuffix("facebook.com") ||
                                host.hasSuffix("m.facebook.com")
                
                if isAllowed || url.scheme == "about" {
                    decisionHandler(.allow)
                } else {
                    // Open external links in default macOS browser instead of embedding them
                    NSWorkspace.shared.open(url)
                    decisionHandler(.cancel)
                }
            } else {
                // Allow iframe content, scripts, stylesheets to load
                decisionHandler(.allow)
            }
        }

        // Handle target="_blank" and window.open popup links inside the same web view (essential for OAuth login popups)
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "chessMac" else { return }
            guard let body = message.body as? [String: Any],
                  let action = body["action"] as? String else { return }
            
            DispatchQueue.main.async {
                guard let webView = message.webView,
                      let window = webView.window else { return }
                
                let isFullscreen = window.styleMask.contains(.fullScreen)
                
                if action == "enterFullscreen" {
                    if !isFullscreen {
                        window.toggleFullScreen(nil)
                    }
                } else if action == "exitFullscreen" {
                    if isFullscreen {
                        window.toggleFullScreen(nil)
                    }
                }
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.parent.canGoBack = webView.canGoBack
                self.parent.canGoForward = webView.canGoForward
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }
    }
}
