import AuthenticationServices
import Combine
import SwiftUI
import TMDBRepository
import Utils

/// ViewModel responsible for managing the sign-in feature's authentication flow with TMDB.
/// 
/// This class handles the various states and actions involved in authenticating a user,
/// including fetching request tokens, presenting authorization URLs, handling user interactions,
/// and retrieving session tokens. The ViewModel does not handle UI presentation directly; instead,
/// it exposes state changes that the View observes to update UI accordingly.
/// 
/// The class is marked with `@MainActor` to ensure all UI-related state mutations occur on the main thread,
/// and `@Observable` to automatically generate observable state properties for SwiftUI compatibility.
@MainActor @Observable
public final class SignInFeatureViewModel {
    
    /// The authentication service used to perform TMDB authentication operations such as fetching tokens.
    private let authenticationService: TMDBAuthenticationService
    
    /// Keychain store used to securely save sensitive session information.
    private let keychainStore: KeychainStore

    /// Initializes the view model with the provided authentication service.
    /// - Parameters:
    ///   - authenticationService: The service responsible for TMDB authentication operations.
    ///   - keychainStore: The keychain store to save the session token securely.
    ///
    /// Note: The ViewModel no longer handles presenting the web authentication UI.
    /// The View is responsible for presenting the web authentication sheet using the URL provided in the `.requestingUserPermissions` state.
    public init(authenticationService: TMDBAuthenticationService, keychainStore: KeychainStore) {
        self.authenticationService = authenticationService
        self.keychainStore = keychainStore
    }

    /// Represents the current authentication state of the sign-in feature.
    ///
    /// This enum captures the entire authentication flow from initialization,
    /// through loading and user authorization, to final session token retrieval or failure.
    /// The View observes this state to update UI and handle navigation.
    public enum State: Equatable {
        /// Initial state before any authentication action has been taken.
        case initialized
        /// Indicates that a network request or asynchronous operation is in progress.
        case loading
        /// The request token has been successfully fetched from the server.
        case fetchedRequestToken(RequestToken)
        /// Waiting for the user to authorize the request token.
        /// Carries the request token and the URL for the user authorization page.
        /// The View is responsible for presenting the web authentication UI using this URL.
        case requestingUserPermissions(RequestToken, authURL: URL)
        /// The process of fetching the session token is underway after user authorization.
        case fetchingSessionToken
        /// The session token has been successfully fetched and authentication is complete.
        case fetchedSessionToken
        /// An error occurred during any step of the authentication process.
        /// Carries a descriptive error message.
        case failed(String)
    }
    
    /// Defines the possible actions that can be performed within the sign-in feature.
    ///
    /// Actions represent user interactions or lifecycle events that trigger state transitions.
    public enum Action {
        /// Starts the process of fetching a new request token.
        case fetchRequestToken
        /// Triggered when the user taps the sign-in button to begin authorization.
        case signInButtonTapped
        /// Attempts to fetch a session token using the provided request token.
        case fetchSessionToken(RequestToken)
        /// Indicates the user has completed authentication via the web UI and returned with a callback URL.
        case userDidAuthenticate(RequestToken, URL)
        /// Indicates the user cancelled the authentication process.
        case userDidCancelAuthentication(RequestToken)
    }
    
    /// Outputs that the ViewModel can emit to notify the View about navigation or other external events.
    public enum Output {
        /// Indicates that the View should navigate to the home screen after successful sign-in.
        case navigateToHome
    }
    
    /// The current state of the sign-in feature, reflecting the latest authentication status.
    private(set) var state: State = .initialized

    /// Processes an incoming action to update the ViewModel's state accordingly.
    ///
    /// This method encapsulates the logic for handling user events and asynchronous authentication steps,
    /// transitioning through states and triggering side effects as necessary.
    /// - Parameter action: The action to process.
    ///
    /// Note: When transitioning to `.requestingUserPermissions`, the View should present the web authentication UI.
    func reduce(_ action: Action) async {
        do {
            switch action {
            case .fetchRequestToken:
                state = .loading
                let requestToken = try await authenticationService.requestToken()
                state = .fetchedRequestToken(requestToken)
                
            case .signInButtonTapped:
                guard case let .fetchedRequestToken(requestToken) = state else {
                    await reduce(.fetchRequestToken)
                    return
                }
                
                let authURL = authenticationService.authorizationURL(for: requestToken.requestToken)
                state = .requestingUserPermissions(requestToken, authURL: authURL)
                
            case .fetchSessionToken(let requestToken):
                state = .fetchingSessionToken
                let _ = try await authenticationService.sessionToken(
                    requestToken: requestToken.requestToken
                )
                state = .fetchedSessionToken
            case .userDidAuthenticate(let requestToken, let callbackURL):
                guard let components = URLComponents(
                    url: callbackURL,
                    resolvingAgainstBaseURL: false
                ),
                let queryItems = components.queryItems else {
                    // Unexpected URL, treat as cancellation
                    state = .fetchedRequestToken(requestToken)
                    return
                }
                
                Task { [reduce] in
                    // Check if the user denied permission
                    if queryItems.contains(where: { $0.name == "denied" && $0.value == "true" }) {
                        await reduce(.fetchRequestToken)
                    } else {
                        await reduce(.fetchSessionToken(requestToken))
                    }
                }
            case .userDidCancelAuthentication(let requestToken):
                state = .fetchedRequestToken(requestToken)
            }
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

