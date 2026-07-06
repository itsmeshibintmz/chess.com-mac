// MARK: - Color+Chess.swift
// Chess.com-inspired color palette & gradients.

import SwiftUI

extension Color {
    // MARK: Brand Colors
    static let chessGreen       = Color(red: 0.506, green: 0.714, blue: 0.298) // #81b64c
    static let chessDarkGreen   = Color(red: 0.463, green: 0.588, blue: 0.337) // #769656
    static let chessLightGreen  = Color(red: 0.588, green: 0.796, blue: 0.380) // #96cb61

    // MARK: Surface & Grays
    static let chessDarkBG      = Color(red: 0.149, green: 0.141, blue: 0.129) // #262421 (classic warm dark)
    static let chessCharcoal    = Color(red: 0.192, green: 0.180, blue: 0.169) // #312e2b (sidebar/boards)
    static let chessMidGray     = Color(red: 0.250, green: 0.235, blue: 0.219) // #403c38
    static let chessLightGray   = Color(red: 0.550, green: 0.540, blue: 0.520) // #8c8a85

    // MARK: Liquid Glass Speculars
    static let glassWhite       = Color.white.opacity(0.10)
    static let glassHighlight   = Color.white.opacity(0.22)
    static let glassBorder      = Color.white.opacity(0.16)
    static let glassShadow      = Color.black.opacity(0.45)
}

extension LinearGradient {
    // Liquid glass surface gradient
    static let liquidGlass = LinearGradient(
        colors: [Color.white.opacity(0.18), Color.white.opacity(0.04)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Specular highlight (top-only reflection)
    static let specularHighlight = LinearGradient(
        colors: [Color.white.opacity(0.28), .clear],
        startPoint: .top,
        endPoint: UnitPoint(x: 0.5, y: 0.35)
    )

    // Window / sidebar background gradient
    static let sidebarGradient = LinearGradient(
        colors: [Color.chessDarkBG, Color.chessCharcoal],
        startPoint: .top,
        endPoint: .bottom
    )
}
