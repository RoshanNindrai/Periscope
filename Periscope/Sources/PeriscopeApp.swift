import AppSetup
import DataModel
import DetailFeature
import HomeFeature
import Lego
import Routes
import SearchFeature
import SignInFeature
import SwiftUI
import TMDBRepository
import TMDBService
import Utils

@main
struct PeriscopeApp: App {
    
    // MARK: - Dependencies and View Models
    
    private let appSetup: PeriscopeAppSetup
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    // MARK: - Routing
    
    @State
    private var router: AppRouter = .init()

    @State
    private var tabSelection: PeriscopeTab = .home
    
    @State
    private var tmdbImageURLBuilder: TMDBImageURLBuilder = .init(
        configuration: .default
    )

    @Namespace
    private var namespace: Namespace.ID

    // MARK: - Initialization
    
    init() {
        appSetup = PeriscopeAppSetup(
            dependencies: AppSetupDependencies()
        )
    }
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                PeriscopeAppView(
                    appSetup: appSetup,
                    router: $router,
                    namespace: namespace,
                    tabSelection: $tabSelection
                )
            }
            .task {
                tmdbImageURLBuilder = await appSetup.repositoryContainer
                    .tmdbRepository
                    .imageURLBuilder()
            }
            .tint(styleSheet.colors.primary)
            .environment(\.colorScheme, .dark)
        }
        .environment(\.tmdbImageURLBuilder, tmdbImageURLBuilder)
        .environment(\.appRouter, router)
    }
}
