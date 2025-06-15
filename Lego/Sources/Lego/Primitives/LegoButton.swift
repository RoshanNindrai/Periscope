import SwiftUI

/// A customizable button component supporting multiple styles and content, designed for use with consistent theming.
///
/// `LegoButton` allows injection of a label view, custom button content, and an optional modifier for additional customization.
/// - Parameters:
///   - Label: The type of view used for the button's label.
///   - ContentView: The type of the view returned from the button modifier, usually just the button itself.
///
/// Example usage:
/// ```swift
/// LegoButton(style: .primary, label: { LegoText("Click Me", style: .title) }, onTap: { ... })
/// ```
public struct LegoButton<Label: View, ContentView: View>: View {
    
    /// Predefined styles for LegoButton appearance.
    public enum ButtonStyle {
        /// A prominent button style for primary actions.
        case primary
        /// A subtle button style for secondary actions.
        case secondary
        /// An error button style, typically used to indicate destructive actions.
        case error
    }
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    private let style: ButtonStyle
    private let label: () -> Label
    private let onTap: () -> Void
    private let buttonModifier: (Button<Label>) -> ContentView
    
    /// Creates a LegoButton with full customization, allowing an additional modifier for the button.
    /// - Parameters:
    ///   - style: The button's visual style.
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
    /// - Parameters:
    ///   - style: The button's visual style.
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
            .background(backgroundColor)
            .cornerRadius(styleSheet.spacing.spacing50)
    }
}

private extension LegoButton {
    var backgroundColor: SwiftUI.Color {
        switch style {
            case .primary:
            styleSheet.colors.primary
        case .secondary:
            styleSheet.colors.surface
        case .error:
            styleSheet.colors.error
        }
    }
}

#Preview {
    LegoButton(
        style: .primary,
        label: {
            LegoText("Primary", style: .title) { $0 }
        },
        onTap: {}
    )
    
    // Secondary button with text
    LegoButton(
        style: .secondary,
        label: {
            LegoText("Secondary", style: .body) { $0 }
        },
        onTap: {}
    )
    
    // Error button with text
    LegoButton(
        style: .error,
        label: {
            LegoText("Error", style: .body) { $0 }
        },
        onTap: {}
    )
    
    // Primary button with async image
    LegoButton(
        style: .primary,
        label: {
            HStack {
                Image(systemName: "star.fill").tint(.white)
                LegoText("Image Button", style: .body) { $0 }
            }
        },
        onTap: {}
    )
}
