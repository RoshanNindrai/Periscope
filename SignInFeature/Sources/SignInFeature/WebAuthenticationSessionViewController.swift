import AuthenticationServices
import SwiftUI

struct WebAuthenticationSessionViewController: UIViewControllerRepresentable {

    private let authenticationURL: URL
    private let callbackURLScheme: String
    private let onCompletion: (Result<URL, Error>) -> Void
    
    init(
        authenticationURL: URL,
        callbackURLScheme: String,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) {
        self.authenticationURL = authenticationURL
        self.callbackURLScheme = callbackURLScheme
        self.onCompletion = onCompletion
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onCompletion: onCompletion)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        
        context.coordinator.startAutnetication(
            url: authenticationURL,
            callbackURLScheme: callbackURLScheme
        )
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        return
    }
}

// MARK: - Coordinator

extension WebAuthenticationSessionViewController {
    
    final class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASWebAuthenticationPresentationContextProviding {

        private let onCompletion: (Result<URL, Error>) -> Void
        private var authenticationSession: ASWebAuthenticationSession?
        
        init(onCompletion: @escaping (Result<URL, Error>) -> Void) {
            self.onCompletion = onCompletion
        }
        
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
        
        func startAutnetication(url: URL, callbackURLScheme: String) {
            
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

