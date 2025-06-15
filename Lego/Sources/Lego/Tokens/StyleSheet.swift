import SwiftUI

public protocol StyleSheet: Sendable {
    var colors: Color { get }
    var typography: Typography { get }
    var spacing: Spacing { get }
}

struct LegoStyleSheet: StyleSheet {
    let colors: Color = .init()
    let typography: Typography = .init()
    let spacing: Spacing = .init()
}

public struct StyleSheetEnvironmentKey: EnvironmentKey {
    public static let defaultValue: StyleSheet = LegoStyleSheet()
}

public extension EnvironmentValues {
    var styleSheet: StyleSheet {
        get {
            self[StyleSheetEnvironmentKey.self]
        } set {
            self[StyleSheetEnvironmentKey.self] = newValue
        }
    }
}
