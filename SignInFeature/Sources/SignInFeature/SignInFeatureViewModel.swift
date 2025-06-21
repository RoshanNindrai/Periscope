import TMDBRepository
import SwiftUI
import Combine
import AuthenticationServices
import Utils

@MainActor @Observable
public final class SignInFeatureViewModel {
    
    private let authenticationService: TMDBAuthenticationService
    private var webAuthenticationSession: ASWebAuthenticationSession?
    private let webPresentationContextProvider = DefaultWebPresentationContextProvider()
    private let keychainStore: KeychainStore

    /// Initializes the view model with the provided authentication service.
    /// - Parameter authenticationService: The service responsible for TMDB authentication operations.
    public init(authenticationService: TMDBAuthenticationService, keychainStore: KeychainStore) {
        self.authenticationService = authenticationService
        self.keychainStore = keychainStore
    }

    /// Represents the current authentication state of the sign-in feature.
    public enum State {
        /// Initial, no actions performed yet.
        case initialized
        /// Indicates an ongoing network operation.
        case loading
        /// Request token fetched from the server.
        case fetchedRequestToken(RequestToken)
        /// Waiting for user to authorize the request token. Carries the token.
        case requestingUserPermissions(RequestToken)
        /// Attempting to fetch the session token after user authorization.
        case fetchingAccessToken
        /// Successfully fetched the session token after user authorization.
        case fetchedAccessToken
        /// An error occurred during any authentication step.
        case failed(Error)
    }
    
    /// Represents the actions that can be performed in the sign-in feature.
    public enum Action {
        /// Starts fetching the request token.
        case fetchRequestToken
        /// Triggered when the sign-in button is tapped.
        case signInButtonTapped
        /// Fetches the access token using a request token.
        case fetchAccessToken(RequestToken)
    }
    
    /// The current state of the sign-in feature.
    private(set) var state: State = .initialized

    /// Processes an action and updates the state accordingly.
    /// - Parameter action: The action to process.
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
                // Update state carrying the token and present authentication web.
                state = .requestingUserPermissions(requestToken)
                await presentAuthenticationWeb(for: requestToken)
                
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
            }
        } catch {
            state = .failed(error)
        }
    }
}

private extension SignInFeatureViewModel {
    /// Presents the web authentication session for the given request token and waits for user authentication.
    ///
    /// This method initiates an `ASWebAuthenticationSession` to allow the user to authorize the request token.
    /// The completion handler is executed asynchronously to avoid blocking the current thread,
    /// hence the use of `Task` inside the closure.
    ///
    /// - Parameter requestToken: The request token to be authorized.
    @MainActor
    func presentAuthenticationWeb(for requestToken: RequestToken) async {
        let authURL = authenticationService.authorizationURL(for: requestToken.requestToken)
        let callbackURLScheme = "periscope"
        
        webAuthenticationSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: callbackURLScheme
        ) { [weak self] callbackURL, error in
            defer { self?.webAuthenticationSession = nil }
            
            // Handle error first
            if error != nil {
                self?.state = .fetchedRequestToken(requestToken)
                return
            }

            guard let callbackURL = callbackURL,
                  let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                  let queryItems = components.queryItems else {
                // Unexpected URL, treat as cancellation
                self?.state = .fetchedRequestToken(requestToken)
                return
            }
            
            // Check if the user denied permission
            if queryItems.contains(where: { $0.name == "denied" && $0.value == "true" }) {
                Task { [weak self] in
                    await self?.reduce(.fetchRequestToken)
                }
                return
            }

            // All good, proceed to fetch access token
            Task { [weak self] in
                await self?.reduce(.fetchAccessToken(requestToken))
            }
        }

        webAuthenticationSession?.presentationContextProvider = webPresentationContextProvider
        webAuthenticationSession?.start()
    }
}

private class DefaultWebPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // Return the first window of the connected scenes or fallback to a new window
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            return window
        }
        fatalError("No active window")
    }
}
