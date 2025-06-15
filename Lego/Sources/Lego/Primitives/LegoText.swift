import SwiftUI

/// A stylable text view for consistent typography and color, based on the application's StyleSheet.
///
/// Use `LegoText` to display text in your app with easily configurable styles (title, subtitle, body, callout, caption).
/// You can further customize the appearance by providing a `textModifier` closure.
///
/// Example:
/// ```swift
/// LegoText(
///     "Welcome!",
///     style: styleSheet.text(.title)
/// ) {
///     $0.multilineTextAlignment(.center)
/// }
/// ```
public struct LegoText<ContentView: View>: View {
    
    @Environment(\.styleSheet)
    var styleSheet: StyleSheet
    
    private let verbatim: String
    
    private let style: TextStyle
    
    private let textModifier: (Text) -> ContentView
    
    public init(
        _ text: String,
        style: TextStyle,
        textModifier: @escaping (Text) -> ContentView = { $0 }
    ) {
        self.verbatim = text
        
        self.style = style
        
        self.textModifier = textModifier
    }
    
    public var body: some View {
        textModifier(Text(verbatim))
            .font(style.textFont)
            .foregroundColor(style.textColor)
    }
}

extension LegoText {
    
    public enum TextType {
        case title
        case subtitle
        case body
        case callout
        case caption
    }
    
    public struct TextStyle {
        let textColor: SwiftUI.Color
        
        let textFont: Font
    }
}

public extension StyleSheet {
    
    func text<Content: View>(_ style: LegoText<Content>.TextType) -> LegoText<Content>.TextStyle {
        switch style {
        case .title:
            return LegoText<Content>.TextStyle(textColor: colors.textPrimary, textFont: typography.title)
            
        case .subtitle:
            return LegoText<Content>.TextStyle(textColor: colors.textSecondary, textFont: typography.subtitle)
            
        case .body:
            return LegoText<Content>.TextStyle(textColor: colors.textPrimary, textFont: typography.body)
            
        case .callout:
            return LegoText<Content>.TextStyle(textColor: colors.textSecondary, textFont: typography.callout)
            
        case .caption:
            return LegoText<Content>.TextStyle(textColor: colors.textSecondary, textFont: typography.caption)
        }
    }
}

#Preview {
    
    let styleSheet = LegoStyleSheet()
    
    LegoText("Welcome to the Galactic Library", style: styleSheet.text(.title)) {
        $0.multilineTextAlignment(.center)
    }
    
    LegoText("Welcome to the Galactic Library", style: styleSheet.text(.subtitle)) {
        $0.multilineTextAlignment(.center)
    }
    
    LegoText("Welcome to the Galactic Library", style: styleSheet.text(.body)) {
        $0.multilineTextAlignment(.center)
    }
    
    LegoText("Welcome to the Galactic Library", style: styleSheet.text(.callout)) {
        $0.multilineTextAlignment(.center)
    }
    
    LegoText("Welcome to the Galactic Library", style: styleSheet.text(.caption)) {
        $0.multilineTextAlignment(.center)
    }
}
