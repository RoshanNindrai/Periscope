import SwiftUI

/// Defines the navigation routes available in the app.
/// Used to control high-level navigation states.
public enum AppRoute: Equatable {
    /// No active route or navigation state.
    case none
    /// Route representing the sign-in screen.
    case signIn
    /// Route representing the landing screen after sign-in.
    case landing
    /// Route for displaying the detail screen for a selected media item.
    case detail(MediaSelection)
    /// Route representing the media search screen.
    case search
}

///
/// AppRouter is responsible for managing and controlling the app's navigation state, including keeping track of current, previous routes, and any associated animation namespace. Use it to programmatically navigate or reset navigation.
///
@MainActor
@Observable
public final class AppRouter: Sendable {
    
    /// The current active navigation route.
    public private(set) var currentRoute: AppRoute
    
    /// The last active navigation route prior to the most recent change.
    @ObservationIgnored
    public private(set) var previousRoute: AppRoute
    
    /// The current SwiftUI namespace used for animations (if any).
    @ObservationIgnored
    public private(set) var namespace: Namespace.ID?

    /// Creates a new AppRouter with no active or previous navigation route.
    public init() {
        previousRoute = .none
        currentRoute = .none
    }
    
    /// Navigate to a specified route.
    /// - Parameter route: The destination route to navigate to.
    public func navigate(to route: AppRoute, in namespace: Namespace.ID? = nil) {
        self.namespace = namespace
        previousRoute = currentRoute
        currentRoute = route
    }
    
    /// Resets the current route to `.none`, typically used to dismiss modals or reset navigation.
    public func reset() {
        previousRoute = currentRoute
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
