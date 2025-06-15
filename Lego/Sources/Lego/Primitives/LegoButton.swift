import SwiftUI


/// A customizable button component supporting multiple styles and content, designed for use with consistent theming.
/// 
/// `LegoButton` allows you to inject a label view, custom button content, and an optional modifier for additional customization.
/// 
/// The preferred way to style a `LegoButton` is by passing a `ButtonStyle` instance, which can be obtained from your theme's `StyleSheet` via the `.button(_:)` method.
/// This approach ensures consistent theming across your app.
///
/// - Parameters:
///   - Label: The type of view used for the button's label.
///   - ContentView: The type of the view returned from the button modifier, usually just the button itself.
/// 
/// Example usage:
/// ```swift
/// LegoButton(
///     style: styleSheet.button(.primary),
///     label: { LegoText("Click Me", style: styleSheet.text(.title)) },
///     onTap: { ... }
/// )
/// ```
public struct LegoButton<Label: View, ContentView: View>: View {

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet


    private let style: ButtonStyle

    private let label: () -> Label

    private let onTap: () -> Void

    private let buttonModifier: (Button<Label>) -> ContentView


    /// Creates a LegoButton with full customization, allowing an additional modifier for the button.
    ///
    /// This initializer is useful when you want to apply custom modifiers to the button beyond the default styling.
    ///
    /// - Parameters:
    ///   - style: The button's visual style, as a `ButtonStyleSheet` instance.
    ///   - label: A closure returning the view for the button's label.
    ///   - onTap: The action to perform when tapped.
    ///   - buttonModifier: A modifier closure allowing further customization of the button.
    public init(
        style: ButtonStyle,
        label: @escaping () -> Label,
        onTap: @escaping () -> Void,
        buttonModifier: @escaping (Button<Label>) -> ContentView
    ) {
        self.style = style
        self.label = label
        self.onTap = onTap
        self.buttonModifier = buttonModifier
    }


    /// Creates a LegoButton with no additional modifier, returning a plain button.
    ///
    /// Use this initializer for typical use cases where no extra customization of the button is needed.
    ///
    /// - Parameters:
    ///   - style: The button's visual style, as a `ButtonStyleSheet` instance.
    ///   - label: A closure returning the view for the button's label.
    ///   - onTap: The action to perform when tapped.
    public init(
        style: ButtonStyle,
        label: @escaping () -> Label,
        onTap: @escaping () -> Void
    ) where ContentView == Button<Label> {
        self.init(
            style: style,
            label: label,
            onTap: onTap,
            buttonModifier: { $0 }
        )
    }


    /// The content and layout of the button.
    public var body: some View {
        let button = Button<Label> {
            onTap()
        } label: {
            label()
        }

        return buttonModifier(button)
            .padding(styleSheet.spacing.spacing200)
            .foregroundColor(style.foregroundColor)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
    }
}


/// A stylable button view for consistent appearance, based on the application's StyleSheet.
extension LegoButton {
    /// Predefined roles for button styles, indicating the common use cases for each style.
    ///
    /// Use `.primary` for the main call-to-action buttons, `.secondary` for less prominent actions, and `.error` for destructive or error-related actions.
    public enum ButtonType {
        /// A prominent button style for primary actions.
        case primary
        /// A subtle button style for secondary actions.
        case secondary
        /// An error button style, typically used to indicate destructive actions.
        case error
    }
    

    /// Defines the visual styling attributes of a button.
    ///
    /// This struct controls the background color, foreground (text/icon) color, and corner radius of the button.
    /// Use this style sheet to configure the appearance consistently across your app.
    public struct ButtonStyle {
        let backgroundColor: SwiftUI.Color
        let foregroundColor: SwiftUI.Color
        let cornerRadius: CGFloat
    }
}


public extension StyleSheet {

    /// Returns the appropriate `ButtonStyleSheet` for a given button role.
    ///
    /// This is the preferred method to obtain style values for buttons, ensuring consistent appearance based on their semantic role.
    ///
    /// - Parameter style: The semantic role of the button.
    /// - Returns: A `ButtonStyleSheet` containing background color, foreground color, and corner radius for the button.
    func button<Label: View, Content: View>(
        _ style: LegoButton<Label, Content>.ButtonType
    ) -> LegoButton<Label, Content>.ButtonStyle {
        switch style {
        case .primary:
            return LegoButton<Label, Content>.ButtonStyle(
                backgroundColor: colors.primary,
                foregroundColor: .white,
                cornerRadius: 8
            )
        case .secondary:
            return LegoButton<Label, Content>.ButtonStyle(
                backgroundColor: colors.surface,
                foregroundColor: colors.textPrimary,
                cornerRadius: 8
            )
        case .error:
            return LegoButton<Label, Content>.ButtonStyle(
                backgroundColor: colors.error,
                foregroundColor: .white,
                cornerRadius: 8
            )
        }
    }
}


#Preview {

    let styleSheet = LegoStyleSheet()
    
    LegoButton(
        style: styleSheet.button(.primary),
        label: {
            LegoText("Primary", style: styleSheet.text(.title)) { $0 }
        },
        onTap: {}
    )
    

    // Secondary button with text
    LegoButton(
        style: styleSheet.button(.secondary),
        label: {
            LegoText("Secondary", style: styleSheet.text(.body)) { $0 }
        },
        onTap: {}
    )
    

    // Error button with text
    LegoButton(
        style: styleSheet.button(.error),
        label: {
            LegoText("Error", style: styleSheet.text(.body)) { $0 }
        },
        onTap: {}
    )
    

    // Primary button with async image
    LegoButton(
        style: styleSheet.button(.primary),
        label: {
            HStack {
                Image(systemName: "star.fill").tint(.white)
                LegoText("Image Button", style: styleSheet.text(.body)) { $0 }
            }
        },
        onTap: {}
    )
    
}
