import SwiftUI

/// Defines the navigation routes available in the app.
/// Used to control high-level navigation states.
public enum AppRoute: Equatable {
    /// No active route or navigation state.
    case none
    /// Route representing the sign-in screen.
    case signIn
    /// Route representing the home screen after sign-in.
    case home
    
    case detail(MediaSelection)
}

/// Manages the current navigation state of the app.
/// Responsible for navigating between high-level routes and resetting navigation state.
@MainActor
@Observable
public final class AppRouter: Sendable {
    
    /// The current active route in the app.
    public private(set) var currentRoute: AppRoute

    /// Initializes the router with no active route.
    public init() {
        currentRoute = .none
    }
    
    /// Navigate to a specified route.
    /// - Parameter route: The destination route to navigate to.
    public func navigate(to route: AppRoute) {
        currentRoute = route
    }
    
    /// Resets the current route to `.none`, typically used to dismiss modals or reset navigation.
    public func reset() {
        currentRoute = .none
    }
}

/// Environment key for injecting the app router into SwiftUI environment.
public struct AppRouterEnvironmentKey: EnvironmentKey {
    /// Default value for the app router environment key is `nil`.
    public static let defaultValue: AppRouter? = nil
}

public extension EnvironmentValues {
    /// Accessor for the app router from the SwiftUI environment.
    var appRouter: AppRouter? {
        get { self[AppRouterEnvironmentKey.self] }
        set { self[AppRouterEnvironmentKey.self] = newValue }
    }
}

/// Environment key for injecting an optional SwiftUI Namespace.ID into the environment.
public struct NamespaceEnvironmentKey: EnvironmentKey {
    /// Default value for the namespace environment key is `nil` (no namespace injected).
    public static let defaultValue: Namespace.ID? = nil
}

/// Extension to provide convenient access to the namespace environment value.
public extension EnvironmentValues {
    /// Accessor for the namespace from the SwiftUI environment.
    /// A Namespace may or may not be injected from a parent view; this value is optional.
    var namespace: Namespace.ID? {
        get { self[NamespaceEnvironmentKey.self] }
        set { self[NamespaceEnvironmentKey.self] = newValue }
    }
}
