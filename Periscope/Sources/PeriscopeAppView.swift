import AppSetup
import SwiftUI
import HomeFeature
import SearchFeature
import SignInFeature
import DetailFeature
import Lego
import Routes
import TMDBRepository
import TMDBService
import DataModel

enum PeriscopeTab: Hashable {
    case home
    case search
}

struct PeriscopeAppView: View {
    
    let appSetup: PeriscopeAppSetup
    let namespace: Namespace.ID
    
    @Binding
    private var router: AppRouter
    
    @Binding
    private var tabSelection: PeriscopeTab

    init(
        appSetup: PeriscopeAppSetup,
        router: Binding<AppRouter>,
        namespace: Namespace.ID,
        tabSelection: Binding<PeriscopeTab>
    ) {
        self.appSetup = appSetup
        self._router = router
        self.namespace = namespace
        self._tabSelection = tabSelection
    }

    var body: some View {
        switch router.currentRoute {
        case .landing, .search, .detail:
            tabView
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

    @ViewBuilder
    private var tabView: some View {
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
                        namespace: router.namespace ?? namespace
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
                        namespace: router.namespace ?? namespace
                    )
                }
            }
        }
    }

    private var tabSelectionBinding: Binding<PeriscopeTab> {
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
