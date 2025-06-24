import TMDBRepository
import SwiftUI
import Combine
import AuthenticationServices
import Utils

@MainActor @Observable
public final class SignInFeatureViewModel {
    
    private let authenticationService: TMDBAuthenticationService
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
    /// The `.requestingUserPermissions` state includes the URL for user authorization.
    /// The View should observe this state and present the web authentication sheet accordingly.
    public enum State: Equatable {
        /// Initial, no actions performed yet.
        case initialized
        /// Indicates an ongoing network operation.
        case loading
        /// Request token fetched from the server.
        case fetchedRequestToken(RequestToken)
        /// Waiting for user to authorize the request token. Carries the token and authorization URL.
        /// The View is responsible for presenting the web authentication UI using this URL.
        case requestingUserPermissions(RequestToken, authURL: URL)
        /// Attempting to fetch the session token after user authorization.
        case fetchingAccessToken
        /// Successfully fetched the session token after user authorization.
        case fetchedAccessToken
        /// An error occurred during any authentication step.
        case failed(String)
    }
    
    /// Represents the actions that can be performed in the sign-in feature.
    public enum Action {
        /// Starts fetching the request token.
        case fetchRequestToken
        /// Triggered when the sign-in button is tapped.
        case signInButtonTapped
        /// Fetches the access token using a request token.
        case fetchAccessToken(RequestToken)
        
        case userDidAuthenticate(RequestToken, URL)
        
        case userDidCancelAuthentication(RequestToken)
    }
    
    /// The current state of the sign-in feature.
    private(set) var state: State = .initialized

    /// Processes an action and updates the state accordingly.
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
                
            case .fetchAccessToken(let requestToken):
                state = .fetchingAccessToken
                let sessionToken = try await authenticationService.sessionToken(
                    requestToken: requestToken.requestToken
                )
                keychainStore.set(
                    sessionToken.sessionId,
                    forKey: SignInFeatureConsts.sessionIdKey
                )
                state = .fetchedAccessToken
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
                
                // Check if the user denied permission
                if queryItems.contains(where: { $0.name == "denied" && $0.value == "true" }) {
                    Task { [weak self] in
                        await self?.reduce(.fetchRequestToken)
                    }
                    return
                }

            case .userDidCancelAuthentication(let requestToken):
                state = .fetchedRequestToken(requestToken)
            }
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
