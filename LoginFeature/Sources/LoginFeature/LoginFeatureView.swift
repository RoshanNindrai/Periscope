import Lego
import SwiftUI

public struct LoginFeatureView: View {
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    public var body: some View {
        VStack {
            Spacer()
            titleView
            Spacer()
            signInButton
        }
        .padding(.horizontal, styleSheet.spacing.spacing300)
        .background {
            CinematicBackgroundView()
        }
    }
}

private extension LoginFeatureView {
    
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

    // Localized: "Sign in"
    var signInButton: some View {
        LegoButton(
            style: styleSheet.button(.primary),
            key: LocalizedStringKey("Sign in"),
            bundle: .module,
            textStyle: styleSheet.text(.title),
            onTap: { },
            buttonModifier: { button in
                button.frame(maxWidth: .infinity)
            }
        )
    }
}

#Preview {
    LoginFeatureView()
}
