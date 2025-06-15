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
    
    private let type: ProgressViewType
    
    init(type: ProgressViewType = .medium) {
        self.type = type
    }
    
    public var body: some View {
        ProgressView()
            .padding(styleSheet.spacing.spacing100)
            .tint(styleSheet.colors.primary)
            .scaleEffect(size / 8)
    }
}

extension LegoProgressView {
    public enum ProgressViewType {
        case small
        case medium
        case large
    }
}

extension LegoProgressView {
    var size: CGFloat {
        switch type {
        case .small:
            styleSheet.spacing.spacing50
        case .medium:
            styleSheet.spacing.spacing100
        case .large:
            styleSheet.spacing.spacing200
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        LegoProgressView(type: .small)
        LegoProgressView(type: .medium)
        LegoProgressView(type: .large)
    }
    .padding()
}

