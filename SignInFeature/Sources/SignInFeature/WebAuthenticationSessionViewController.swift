import AuthenticationServices
import SwiftUI

/**
 A SwiftUI wrapper for presenting a web authentication session using `ASWebAuthenticationSession`.

 This controller allows you to initiate OAuth or other web-based authentication flows,
 handling the callback and completion in SwiftUI code.
*/
struct WebAuthenticationSessionViewController: UIViewControllerRepresentable {

    /// The URL to start authentication.
    private let authenticationURL: URL
    /// The custom URL scheme to capture the callback.
    private let callbackURLScheme: String
    /// Callback invoked when authentication completes or fails.
    private let onCompletion: (Result<URL, Error>) -> Void
    
    /**
     Initializes a web authentication session view controller.
     - Parameters:
        - authenticationURL: The URL to start authentication.
        - callbackURLScheme: The custom URL scheme for callback.
        - onCompletion: The closure called with the result (success or failure).
    */
    init(
        authenticationURL: URL,
        callbackURLScheme: String,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) {
        self.authenticationURL = authenticationURL
        self.callbackURLScheme = callbackURLScheme
        self.onCompletion = onCompletion
    }
    
    /// Creates the coordinator for managing the authentication session.
    func makeCoordinator() -> Coordinator {
        Coordinator(onCompletion: onCompletion)
    }
    
    /**
     Creates the underlying `UIViewController` and starts the authentication session.
     - Parameter context: The context containing the coordinator.
     - Returns: The created `UIViewController`.
    */
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        
        context.coordinator.startAuthentication(
            url: authenticationURL,
            callbackURLScheme: callbackURLScheme
        )
        
        return viewController
    }
    
    /// No-op: No dynamic updates required for this view controller.
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        return
    }
}

// MARK: - Coordinator

extension WebAuthenticationSessionViewController {
    
    /**
     Coordinator to manage the lifecycle of the web authentication session, including providing the presentation anchor and handling completion.
    */
    final class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASWebAuthenticationPresentationContextProviding {

        /// The closure called with authentication result.
        private let onCompletion: (Result<URL, Error>) -> Void
        /// The current authentication session, if any.
        private var authenticationSession: ASWebAuthenticationSession?
        
        /// Initializes the coordinator with a completion handler.
        init(onCompletion: @escaping (Result<URL, Error>) -> Void) {
            self.onCompletion = onCompletion
        }
        
        /**
         Provides the presentation anchor (window) for the authentication session UI.
         - Parameter session: The session requesting a presentation anchor.
         - Returns: The window scene's presentation anchor.
        */
        func presentationAnchor(
            for session: ASWebAuthenticationSession
        ) -> ASPresentationAnchor {
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                fatalError("No window scene to present")
            }
            
            return ASPresentationAnchor(
                windowScene: windowScene
            )
        }
        
        /**
         Starts the web authentication session with the given URL and callback scheme.
         - Parameters:
           - url: The authentication URL to load.
           - callbackURLScheme: The custom URL scheme to listen for.
        */
        func startAuthentication(url: URL, callbackURLScheme: String) {
            
            guard authenticationSession == nil else {
                fatalError("Authentication session already started, which is not expected")
            }
            
            authenticationSession = ASWebAuthenticationSession(
                url: url,
                callbackURLScheme: callbackURLScheme
            ){ [weak self] callbackURL, error in
                if let error = error {
                    self?.onCompletion(.failure(error))
                    return
                }
                
                guard let callbackURL = callbackURL else {
                    let error = NSError(
                        domain: "com.example.WebAuthenticationSession",
                        code: 1001,
                        userInfo: [NSLocalizedDescriptionKey : "Callback URL is nil"]
                    )
                    self?.onCompletion(.failure(error))
                    return
                }
                
                self?.onCompletion(.success(callbackURL))
            }
            
            authenticationSession?.presentationContextProvider = self
            authenticationSession?.start()
        }
    }
}

