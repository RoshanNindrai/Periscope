import SwiftUI

struct CinematicBackgroundView: View {
    @State private var toggleAnimation = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                toggleAnimation
                    ? Color(red: 0.05, green: 0.02, blue: 0.10)
                    : Color(red: 0.08, green: 0.03, blue: 0.15),
                toggleAnimation
                    ? Color(red: 0.15, green: 0.08, blue: 0.25)
                    : Color(red: 0.12, green: 0.06, blue: 0.20),

                toggleAnimation
                    ? Color.black
                    : Color(red: 0.02, green: 0.01, blue: 0.05)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(
                .linear(duration: 3.0).repeatForever(autoreverses: true)
            ) {
                toggleAnimation.toggle()
            }
        }
    }
}
