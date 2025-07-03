import AppSetup
import DataModel
import HomeFeature
import Lego
import Routes
import SignInFeature
import SwiftUI
import TMDBRepository
import TMDBService
import Utils

@MainActor
@main
struct PeriscopeApp: App {
 
    // MARK: - Dependencies and View Models
    
    private let appSetup: PeriscopeAppSetup
    private let keychainStore: KeychainStore  // Security-sensitive store for credentials
    
    private let homeFeatureViewModel: HomeFeatureViewModel
    private let signInFeatureViewModel: SignInFeatureViewModel
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    // MARK: - Routing
    
    @State
    private var router: AppRouter = .init()
    
    @State
    private var selectedMediaInfo: MediaSelection?
    
    @Namespace
    private var namespace: Namespace.ID
    
    @State
    private var tmdbImageURLBuilder: TMDBImageURLBuilder = .init(configuration: .default)
    
    // MARK: - Initialization
    
    init() {

        appSetup = PeriscopeAppSetup(
            dependencies: AppSetupDependencies()
        )
        
        // KeychainStore handles sensitive authentication data securely
        keychainStore = appSetup.keychainStore
        
        homeFeatureViewModel = HomeFeatureViewModel(
            repository: appSetup.repositoryContainer.tmdbRepository
        )
        
        signInFeatureViewModel = SignInFeatureViewModel(
            authenticationService: appSetup.serviceContainer.tmdbRAuthenticationService,
            keychainStore: keychainStore
        )
    }
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch router.currentRoute {
                    case .home:
                        TabView {
                            Tab("Home", systemImage: "house") {
                                NavigationStack {
                                    HomeFeatureView(
                                        viewModel: homeFeatureViewModel,
                                        selectedMediaInfo: $selectedMediaInfo
                                    )
                                    .navigationTitle("Home")
                                    .navigationDestination(
                                        isPresented: isPresented
                                    ) {
                                        if let selected = selectedMediaInfo {
                                            Text(selected.media.title)
                                                .navigationTransition(.zoom(sourceID: selected, in: namespace))
                                        }
                                    }
                                }
                            }
                        }
                    case .signIn:
                        SignInFeatureView(
                            viewModel: signInFeatureViewModel
                        )
                    case .none:
                        LegoProgressView()
                            .task {
                                // Secure session validation logic for navigation
                                if appSetup.serviceContainer.tmdbRAuthenticationService.haveAnActiveSession() {
                                    router.navigate(to: .home)
                                } else {
                                    router.navigate(to: .signIn)
                                }
                        }
                    }
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
    
    private var isPresented: Binding<Bool> {
        Binding {
            selectedMediaInfo != nil
        } set: { flag in
            if !flag { selectedMediaInfo = nil }
        }
    }
}

