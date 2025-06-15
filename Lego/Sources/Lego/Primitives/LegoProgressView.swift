import SwiftUI

/// A progress indicator view styled according to the application's StyleSheet.
///
/// Use `LegoProgressView` to display a loading spinner that automatically adopts your app's primary color scheme.
/// This ensures a consistent appearance for loading states across your UI.
///
/// Example:
/// ```swift
/// LegoProgressView()
/// ```
public struct LegoProgressView: View {

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    public var body: some View {
        ProgressView()
            .tint(styleSheet.colors.primary)
            .fixedSize()
    }
}

#Preview {
    LegoProgressView()
}
