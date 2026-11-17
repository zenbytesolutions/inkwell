import SwiftUI

/// Inkwell. Strictly black and white: white paper, black ink, greys for hierarchy, serif display type.
public enum Theme {
    public static let paper = Color.white
    public static let sidebar = Color(hex: 0xF6F6F6)
    public static let card = Color.white
    public static let ink = Color(hex: 0x0A0A0A)
    public static let muted = Color(hex: 0x6B6B6B)
    public static let faint = Color(hex: 0xA8A8A8)
    public static let line = Color(hex: 0xE6E6E6)
    /// Highlight fill: selection, bars, hints.
    public static let fill = Color(hex: 0xEDEDED)
    /// Secondary data series, e.g. "others" in a chart.
    public static let fillDeep = Color(hex: 0x7A7A7A)
    /// Errors stay in ink: signal with an icon or copy, not colour.
    public static let danger = Color(hex: 0x0A0A0A)

    public static func display(_ size: CGFloat) -> Font { .system(size: size, weight: .regular, design: .serif) }
    public static func displayItalic(_ size: CGFloat) -> Font { .system(size: size, weight: .regular, design: .serif).italic() }
    public static let body = Font.system(size: 13.5)
    public static let label = Font.system(size: 11, weight: .semibold)
}

public extension Color {
    init(hex: UInt32) {
        self.init(red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255)
    }
}
