import AppSetup
import SignInFeature
import SwiftUI
import SwiftData
import TMDBRepository

@main
struct PeriscopeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @Environment(\.appSetup.serviceContainer.tmdbRAuthenticationService)
    private var authenticationService: TMDBAuthenticationService

    var body: some Scene {
        WindowGroup {
            SignInFeatureView(
                viewModel: SignInFeatureViewModel(
                    authenticationService: authenticationService
                )
            )
        }
        .modelContainer(sharedModelContainer)
    }
}
