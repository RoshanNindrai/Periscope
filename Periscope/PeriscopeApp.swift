//
//  PeriscopeApp.swift
//  
//  Entry point of the Periscope application.
//  Manages app lifecycle, navigation, and core dependencies with a focus on secure authentication handling and modular architecture.
//

import AppSetup
import HomeFeature
import Lego
import Routes
import SignInFeature
import SwiftUI
import TMDBRepository
import Utils

@MainActor
@main
struct PeriscopeApp: App {
 
    // MARK: - Dependencies and View Models
    
    private let appSetup: PeriscopeAppSetup
    private let keychainStore: KeychainStore  // Security-sensitive store for credentials
    
    private let homeFeatureViewModel: HomeFeatureViewModel
    private let signInFeatureViewModel: SignInFeatureViewModel
    
    // MARK: - Routing
    
    @State private var router: AppRouter = .init()
    
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
            switch router.currentRoute {
            case .home:
                HomeFeatureView(
                    viewModel: homeFeatureViewModel
                )
                
            case .signIn:
                SignInFeatureView(
                    viewModel: signInFeatureViewModel
                ) { _ in
                    router.navigate(to: .home)
                }
                
            case .none:
                // Initial loading state with a progress view.
                // Checks if there's an active authenticated session and routes accordingly.
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
        .environment(\.appRouter, router)
    }
}

