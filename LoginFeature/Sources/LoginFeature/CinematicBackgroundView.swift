import SwiftUI

struct CinematicBackgroundView: View {
    var body: some View {
        ZStack {
            // Matte-style deep purple/charcoal gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.07, green: 0.05, blue: 0.10), // top-left matte purple
                    Color(red: 0.02, green: 0.01, blue: 0.05)  // bottom-right near-black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}
