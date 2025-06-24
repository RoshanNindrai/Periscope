import Lego
import SwiftUI
import AuthenticationServices

public struct SignInFeatureView: View {
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    private let viewModel: SignInFeatureViewModel
    
    @State private var isPresentingWebAuth = false
    
    public init(viewModel: SignInFeatureViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack {
            Spacer()
            
            titleView
            subtitleView
            
            Spacer()
            
            signInButton
        }
        .padding(.horizontal, styleSheet.spacing.spacing300)
        .background {
            CinematicBackgroundView()
        }
        .task {
            await viewModel.reduce(.fetchRequestToken)
        }
        // Observe viewModel.state for auth URL to trigger Web Authentication Session
        .onChange(of: viewModel.state) { _, newState in
            if case .requestingUserPermissions = newState {
                isPresentingWebAuth = true
            }
        }
        .fullScreenCover(isPresented: $isPresentingWebAuth) {
            if case let .requestingUserPermissions(requestToken, authURL) = viewModel.state {
                WebAuthSessionPresenter(
                    authURL: authURL,
                    callbackScheme: "periscope",
                    onCompletion: { result in
                        isPresentingWebAuth = false
                        Task {
                            switch result {
                            case .success(let callbackURL):
                                await viewModel.reduce(.userDidAuthenticate(requestToken, callbackURL))
                            case .failure:
                                await viewModel.reduce(.userDidCancelAuthentication(requestToken))
                            }
                        }
                    }
                )
            }
        }
    }
}

private extension SignInFeatureView {
    
    // Localized: "Periscope"
    var titleView: some View {
        LegoText(
            LocalizedStringKey("Periscope"),
            bundle: .module,
            style: styleSheet.text(.largeTitle)
        ) { text in
            text.foregroundColor(.white)
        }
    }
    
    // Localized: "Powered by TMDB"
    var subtitleView: some View {
        LegoText(
            LocalizedStringKey("Powered by TMDB"),
            bundle: .module,
            style: styleSheet.text(.caption)
        ) { text in
            text.foregroundColor(.white)
        }
    }

    // Localized: "Sign in"
    var signInButton: some View {
        LegoButton(
            style: styleSheet.button(.primary),
            key: LocalizedStringKey("Sign in"),
            bundle: .module,
            textStyle: styleSheet.text(.title),
            onTap: {
                Task {
                    await viewModel.reduce(.signInButtonTapped)
                }
            },
            buttonModifier: { button in
                button.frame(maxWidth: .infinity)
            }
        )
    }
}

/// A SwiftUI wrapper view that presents an ASWebAuthenticationSession
private struct WebAuthSessionPresenter: UIViewControllerRepresentable {
    let authURL: URL
    let callbackScheme: String
    let onCompletion: (Result<URL, Error>) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onCompletion: onCompletion)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        
        // Start ASWebAuthenticationSession when the view appears
        context.coordinator.startSession(authURL: authURL, callbackScheme: callbackScheme)
        
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, ASWebAuthenticationPresentationContextProviding {
        private var session: ASWebAuthenticationSession?
        private let onCompletion: (Result<URL, Error>) -> Void

        init(onCompletion: @escaping (Result<URL, Error>) -> Void) {
            self.onCompletion = onCompletion
        }

        func startSession(authURL: URL, callbackScheme: String) {
            session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackScheme) { callbackURL, error in
                if let url = callbackURL {
                    self.onCompletion(.success(url))
                } else if let error = error {
                    self.onCompletion(.failure(error))
                } else {
                    self.onCompletion(.failure(NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)))
                }
            }
            session?.presentationContextProvider = self
            session?.start()
        }

        func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            // Return the first available key window from an active UIWindowScene
            if let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                return keyWindow
            }
            // Fallback: Return any window from any windowScene
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first {
                return window
            }
            // As a last resort, fatalError (should never occur in a live app)
            fatalError("No window available for ASWebAuthenticationSession presentation.")
        }
    }
}

