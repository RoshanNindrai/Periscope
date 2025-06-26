import AuthenticationServices
import Lego
import Routes
import SwiftUI

public struct SignInFeatureView: View {
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.appRouter)
    private var appRouter: AppRouter?
    
    @State
    private var isPresentingWebAuth = false
    
    private let viewModel: SignInFeatureViewModel

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
        .onChange(of: viewModel.state) { _, newState in
            switch newState {
            case .requestingUserPermissions:
                isPresentingWebAuth = true
            case .fetchedSessionToken:
                appRouter?.navigate(to: .home)
            default:
                break
            }
        }
        .fullScreenCover(isPresented: $isPresentingWebAuth) {
            if case let .requestingUserPermissions(requestToken, authURL) = viewModel.state {
                WebAuthenticationSessionViewController(
                    authenticationURL: authURL,
                    callbackURLScheme: "periscope"
                ) { result in
                    Task { @MainActor in
                        switch result {
                        case .success(let callBackURL):
                            await viewModel.reduce(.userDidAuthenticate(requestToken, callBackURL))
                        case .failure:
                            await viewModel.reduce(.userDidCancelAuthentication(requestToken))
                        }
                        
                        // At this point it's safe to say we've dismissed the authentication session vc
                        isPresentingWebAuth.toggle()
                    }
                }
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
