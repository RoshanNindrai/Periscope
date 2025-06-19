import TMDBRepository
import SwiftUI
import Combine
import AuthenticationServices

@MainActor @Observable
public final class LoginFeatureViewModel {
    
    private let authenticationService: TMDBAuthenticationService
    private var webAuthenticationSession: ASWebAuthenticationSession?
    private let webPresentationContextProvider = DefaultWebPresentationContextProvider()

    /// Initializes the view model with the provided authentication service.
    /// - Parameter authenticationService: The service responsible for TMDB authentication operations.
    public init(authenticationService: TMDBAuthenticationService) {
        self.authenticationService = authenticationService
    }

    /// Represents the current authentication state of the login feature.
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
    
    /// Represents the actions that can be performed in the login feature.
    public enum Action {
        /// Starts fetching the request token.
        case fetchRequestToken
        /// Triggered when the sign-in button is tapped.
        case signInButtonTapped
        /// Fetches the access token using a request token.
        case fetchAccessToken(requestToken: String)
    }
    
    /// The current state of the login feature.
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
                await presentAuthenticationWeb(for: requestToken.requestToken)
                
            case .fetchAccessToken(let requestToken):
                state = .fetchingAccessToken
                _ = try await authenticationService.sessionToken(
                    requestToken: requestToken
                )
                state = .fetchedAccessToken
            }
        } catch {
            state = .failed(error)
        }
    }
}

private extension LoginFeatureViewModel {
    /// Presents the web authentication session for the given request token and waits for user authentication.
    ///
    /// This method initiates an `ASWebAuthenticationSession` to allow the user to authorize the request token.
    /// The completion handler is executed asynchronously to avoid blocking the current thread,
    /// hence the use of `Task` inside the closure.
    ///
    /// - Parameter requestToken: The request token to be authorized.
    @MainActor
    func presentAuthenticationWeb(for requestToken: String) async {
        let authURL = authenticationService.authorizationURL(for: requestToken)
        let callbackURLScheme = "periscope"
        
        webAuthenticationSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: callbackURLScheme
        ) { [weak self] callbackURL, error in
            defer { self?.webAuthenticationSession = nil }
            if let error = error {
                // If the authentication session fails, update the state accordingly.
                self?.state = .failed(error)
                return
            }
            
            // Use a Task to asynchronously process fetching the access token without blocking.
            Task { [weak self] in
                await self?.reduce(.fetchAccessToken(requestToken: requestToken))
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
