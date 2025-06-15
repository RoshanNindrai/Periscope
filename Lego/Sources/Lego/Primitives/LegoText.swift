import SwiftUI

/// A stylable text view for consistent typography and color, based on the application's StyleSheet.
///
/// Use `LegoText` to display text in your app with easily configurable styles (title, subtitle, body, callout, caption).
/// You can further customize the appearance by providing a `textModifier` closure.
///
/// Example:
/// ```swift
/// LegoText("Welcome!", style: .title) {
///     $0.multilineTextAlignment(.center)
/// }
/// ```
public struct LegoText<ContentView: View>: View {
    
    public enum TextStyle {
        case title
        case subtitle
        case body
        case callout
        case caption
    }

    @Environment(\.styleSheet)
    var styleSheet: StyleSheet
    
    private let verbatim: String
    private let style: LegoText.TextStyle
    private let textModifier: (Text) -> ContentView
    
    public init(
        _ text: String,
        style: LegoText.TextStyle,
        textModifier: @escaping (Text) -> ContentView = { $0 }
    ) {
        self.verbatim = text
        self.style = style
        self.textModifier = textModifier
    }
    
    public var body: some View {
        textModifier(Text(verbatim))
            .font(font)
            .foregroundColor(foregroundColor)
    }
}

// MARK: - Helpers

private extension LegoText {
    var font: Font {
        switch style {
            case .title:
            styleSheet.typography.title
        case .subtitle:
            styleSheet.typography.subtitle
        case .body:
            styleSheet.typography.body
        case .callout:
            styleSheet.typography.callout
        case .caption:
            styleSheet.typography.caption
        }
    }
    
    var foregroundColor: SwiftUI.Color {
        switch style {
            case .title:
            styleSheet.colors.textPrimary
        case .subtitle, .callout, .caption:
            styleSheet.colors.textSecondary
        case .body:
            styleSheet.colors.textPrimary
        }
    }
}

#Preview {
    LegoText("Welcome to the Galactic Library", style: .title) {
        $0.multilineTextAlignment(.center)
    }
    
    LegoText("Welcome to the Galactic Library", style: .subtitle) {
        $0.multilineTextAlignment(.center)
    }
    
    LegoText("Welcome to the Galactic Library", style: .body) {
        $0.multilineTextAlignment(.center)
    }
    
    LegoText("Welcome to the Galactic Library", style: .callout){
        $0.multilineTextAlignment(.center)
    }
    
    LegoText("Welcome to the Galactic Library", style: .caption){
        $0.multilineTextAlignment(.center)
    }
}
