import AppSetup
import SignInFeature
import HomeFeature
import SwiftUI
import SwiftData
import TMDBRepository
import Utils

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
    
    @Environment(\.appSetup.repositoryContainer.tmdbRepository)
    private var tmdbRepository: TMDBRepository
    
    @Environment(\.appSetup.keychainStore)
    private var keychainStore: KeychainStore

    var body: some Scene {
        WindowGroup {
            if let sessionId = keychainStore.string(forKey: SignInFeatureConsts.sessionIdKey) {
                HomeFeatureView(
                    viewModel: HomeFeatureViewModel(
                        repository: tmdbRepository
                    )
                )
            } else {
                SignInFeatureView(
                    viewModel: SignInFeatureViewModel(
                        authenticationService: authenticationService,
                        keychainStore: keychainStore
                    )
                )
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
