import Lego
import SwiftUI

public struct SignInFeatureView: View {
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
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
    
    // Localized: "Periscope"
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
