import Lego
import SwiftUI

public struct LoginFeatureView: View {
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    public var body: some View {
        VStack {
            Spacer()
            
            LegoText(
                "Periscope",
                style: styleSheet.text(.largeTitle)
            ) { text in
                text.foregroundColor(.white)
            }

            Spacer()

            LegoButton(
                style: styleSheet.button(.primary),
                text: "Sign in",
                textStyle: styleSheet.text(.title),
                onTap: {
                    print("Sign in tapped")
                },
                buttonModifier: { button in
                    button.frame(maxWidth: .infinity)
                }
            )
        }
        .padding(.horizontal, styleSheet.spacing.spacing300)
        .background {
            CinematicBackgroundView()
        }
    }
}

#Preview {
    LoginFeatureView()
}
