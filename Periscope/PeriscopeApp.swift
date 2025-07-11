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

@MainActor
@main
struct PeriscopeApp: App {
    
    enum Tabs {
        case home
        case search
    }
 
    // MARK: - Dependencies and View Models
    
    private let appSetup: PeriscopeAppSetup
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    // MARK: - Routing
    
    @State
    private var router: AppRouter = .init()

    @Namespace
    private var namespace: Namespace.ID
    
    @State
    private var tabSelection: Tabs = .home
    
    @State
    private var tmdbImageURLBuilder: TMDBImageURLBuilder = .init(
        configuration: .default
    )
    
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
                routerRootView()
            }
            .task {
                tmdbImageURLBuilder = await appSetup.repositoryContainer.tmdbRepository.imageURLBuilder()
            }
            .tint(styleSheet.colors.primary)
            .environment(\.colorScheme, .dark)
        }
        .environment(\.tmdbImageURLBuilder, tmdbImageURLBuilder)
        .environment(\.namespace, namespace)
        .environment(\.appRouter, router)
    }
}

private extension PeriscopeApp {
    @ViewBuilder
    func routerRootView() -> some View {
        switch router.currentRoute {
        case .landing, .search, .detail:
            appTabView()
        case .signIn:
            SignInFeatureView(
                viewModel: SignInFeatureViewModel(
                    authenticationService: appSetup.serviceContainer.tmdbRAuthenticationService,
                    keychainStore: appSetup.keychainStore
                )
            )
        case .none:
            LegoProgressView()
                .task {
                    if appSetup.serviceContainer.tmdbRAuthenticationService.haveAnActiveSession() {
                        router.navigate(to: .landing)
                    } else {
                        router.navigate(to: .signIn)
                    }
                }
        }
    }
}

private extension PeriscopeApp {
    @ViewBuilder
    func appTabView() -> some View {
        TabView(selection: tabSelectionBinding) {
            Tab(value: .home) {
                NavigationStack {
                    HomeFeatureView(
                        viewModel: HomeFeatureViewModel(
                            repository: appSetup.repositoryContainer.tmdbRepository
                        )
                    )
                    .navigationTitle("Home")
                    .mediaDetailNavigationDestination(
                        router: router,
                        repository: appSetup.repositoryContainer.tmdbRepository,
                        namespace: namespace
                    )
                }
            } label: {
                Label("Home", systemImage: "house")
            }

            Tab(value: .search, role: .search) {
                NavigationStack {
                    SearchFeatureView(
                        viewModel: SearchFeatureViewModel(
                            repository: appSetup.repositoryContainer.tmdbRepository
                        )
                    )
                    .navigationTitle("Search")
                    .mediaDetailNavigationDestination(
                        router: router,
                        repository: appSetup.repositoryContainer.tmdbRepository,
                        namespace: namespace
                    )
                }
            }
        }
    }
}

private extension View {
    func mediaDetailNavigationDestination(
        router: AppRouter,
        repository: TMDBRepository,
        namespace: Namespace.ID
    ) -> some View {
        
        let selection: Binding<MediaSelection?> = Binding(
            get: {
                if case let .detail(selection) = router.currentRoute {
                    return selection
                }
                return nil
            },
            set: { selection in
                if let selection {
                    router.navigate(to: .detail(selection))
                } else {
                    router.navigate(to: router.previousRoute)
                }
            }
        )
        
        return self.navigationDestination(item: selection) { selectedMediaInfo in
            DetailFeatureView(
                media: selectedMediaInfo.media,
                viewModel: DetailFeatureViewModel(repository: repository)
            )
            .navigationTransition(
                .zoom(sourceID: selectedMediaInfo, in: namespace)
            )
        }
    }
}

private extension PeriscopeApp {
    var tabSelectionBinding: Binding<Tabs> {
        Binding(
            get: {
                switch router.currentRoute {
                case .search:
                    return .search
                case .landing:
                    return .home
                case .detail:
                    return tabSelection
                case .signIn, .none:
                    return .home
                }
            },
            set: { tab in
                tabSelection = tab
                switch tab {
                case .home:
                    router.navigate(to: .landing)
                case .search:
                    router.navigate(to: .search)
                }
            }
        )
    }
}

