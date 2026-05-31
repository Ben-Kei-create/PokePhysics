import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 6:
            (r, g, b, a) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 255)
        case 8:
            (r, g, b, a) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Semantic design tokens
extension Color {
    /// Page / screen background — #F2F2F7 (light) / #1C1C1E (dark)
    static let appBackground = Color(.systemGroupedBackground)

    /// Card surface — white (light) / #2C2C2E (dark)
    static let cardBackground = Color(.secondarySystemGroupedBackground)

    /// Brand accent for text, icons, and tints.
    /// Adapts: #1F355C deep navy (light) → #8BADD4 soft blue (dark)
    static let navyAccent = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark
            ? UIColor(red: 0.545, green: 0.678, blue: 0.831, alpha: 1)
            : UIColor(red: 0.122, green: 0.208, blue: 0.361, alpha: 1)
    })

    /// Fixed deep navy (#1F355C) for filled button backgrounds.
    /// Always dark so white label text maintains contrast.
    static let navyButton = Color(hex: "1F355C")
}
