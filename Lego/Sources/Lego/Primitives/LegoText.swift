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
    private var styleSheet: StyleSheet
    
    /// The localized string key to display.
    private let key: LocalizedStringKey
    
    /// The bundle for string localization. Defaults to nil (main bundle).
    private let bundle: Bundle?
    
    /// Visual style for the text view.
    private let style: TextStyle
    
    /// Closure to customize the Text view (e.g., alignment, line limit).
    private let textModifier: (Text) -> ContentView
    
    /// Initializes LegoText with a plain `String`. For simple, non-localized text.
    public init(
        _ text: String,
        style: TextStyle,
        textModifier: @escaping (Text) -> ContentView = { $0 }
    ) {
        self.key = LocalizedStringKey(text)
        self.bundle = nil
        self.style = style
        self.textModifier = textModifier
    }
    
    /// Initializes LegoText with a `LocalizedStringKey` and optional bundle. Use for localization support.
    public init(
        _ text: LocalizedStringKey,
        bundle: Bundle? = nil,
        style: TextStyle,
        textModifier: @escaping (Text) -> ContentView = { $0 }
    ) {
        self.key = text
        self.bundle = bundle
        self.style = style
        self.textModifier = textModifier
    }
    
    /// Composes and styles the SwiftUI text view, applying any modifier closure.
    public var body: some View {
        textModifier(Text(key, bundle: bundle))
            .font(style.textFont)
            .foregroundColor(style.textColor)
    }
}

extension LegoText {
    
    public enum TextType {
        case largeTitle
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
        case .largeTitle:
            return LegoText<Content>.TextStyle(
                textColor: colors.textPrimary,
                textFont: typography.largeTitle
            )
            
        case .title:
            return LegoText<Content>.TextStyle(
                textColor: colors.textPrimary,
                textFont: typography.title
            )
            
        case .subtitle:
            return LegoText<Content>.TextStyle(
                textColor: colors.textSecondary,
                textFont: typography.subtitle
            )
            
        case .body:
            return LegoText<Content>.TextStyle(
                textColor: colors.textPrimary,
                textFont: typography.body
            )
            
        case .callout:
            return LegoText<Content>.TextStyle(
                textColor: colors.textSecondary,
                textFont: typography.callout
            )
            
        case .caption:
            return LegoText<Content>.TextStyle(
                textColor: colors.textSecondary,
                textFont: typography.caption
            )
        }
    }
}

#Preview {
    let styleSheet = LegoStyleSheet()
    
    LegoText("Welcome to the Galactic Library", style: styleSheet.text(.largeTitle)) {
        $0.multilineTextAlignment(.center)
    }
    
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
