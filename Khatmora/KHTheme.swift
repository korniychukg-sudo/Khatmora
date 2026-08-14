import SwiftUI

extension Color {
    init(khHex: UInt32) {
        let r = Double((khHex >> 16) & 0xFF) / 255.0
        let g = Double((khHex >> 8) & 0xFF) / 255.0
        let b = Double(khHex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

enum KHTheme {
    static let paper = Color(khHex: 0xF7F2E6)
    static let paperDeep = Color(khHex: 0xEFE7D2)
    static let card = Color(khHex: 0xFDFAF1)
    static let ink = Color(khHex: 0x232019)
    static let inkSoft = Color(khHex: 0x585144)
    static let inkFaint = Color(khHex: 0x8B826E)
    static let indigo = Color(khHex: 0x2C3B66)
    static let indigoDeep = Color(khHex: 0x1C2745)
    static let indigoSoft = Color(khHex: 0xDCE0EC)
    static let gold = Color(khHex: 0xB4892F)
    static let goldSoft = Color(khHex: 0xE9D9AC)
    static let rose = Color(khHex: 0x9C4A50)
    static let roseSoft = Color(khHex: 0xEFD9D4)
    static let sage = Color(khHex: 0x5A7059)
    static let sageSoft = Color(khHex: 0xDDE5D9)
    static let line = Color(khHex: 0xDCD2B8)

    static let corner: CGFloat = 18

    static func serif(_ size: CGFloat, _ weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
    static func text(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    static func round(_ size: CGFloat, _ weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
    static func arabic(_ size: CGFloat, _ weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

struct KHCardStyle: ViewModifier {
    var padding: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: KHTheme.corner, style: .continuous)
                    .fill(KHTheme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: KHTheme.corner, style: .continuous)
                            .strokeBorder(KHTheme.line, lineWidth: 1)
                    )
                    .shadow(color: KHTheme.ink.opacity(0.06), radius: 8, x: 0, y: 3)
            )
    }
}

extension View {
    func khCard(padding: CGFloat = 16) -> some View { modifier(KHCardStyle(padding: padding)) }
}
