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
    
    @Environment(\.styleSheet) private var styleSheet: StyleSheet
    
    // MARK: - Routing
    
    @State
    private var router: AppRouter = .init()
    
    @State
    private var selectedMediaInfo: Media?
    
    @Namespace
    private var namespace: Namespace.ID
    
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
                TabView {
                    Tab("Home", systemImage: "house") {
                        NavigationStack {
                            HomeFeatureView(
                                viewModel: homeFeatureViewModel,
                                selectedMediaInfo: $selectedMediaInfo
                            )
                            .navigationTitle("Home")
                            .navigationDestination(
                                isPresented: Binding<Bool>(
                                    get: { selectedMediaInfo != nil },
                                    set: { selectedMediaInfo = $0 ? selectedMediaInfo : nil }
                                )
                            ) {
                                if let selected = selectedMediaInfo {
                                    Text(selected.title)
                                        .navigationTransition(.zoom(sourceID: selected.id, in: namespace))
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .opacity(router.currentRoute == .home ? 1 : 0)
                
                SignInFeatureView(
                    viewModel: signInFeatureViewModel
                ).opacity(router.currentRoute == .signIn ? 1 : 0)
                    
                LegoProgressView()
                    .task {
                        // Secure session validation logic for navigation
                        if appSetup.serviceContainer.tmdbRAuthenticationService.haveAnActiveSession() {
                            router.navigate(to: .home)
                        } else {
                            router.navigate(to: .signIn)
                        }
                }.opacity(router.currentRoute == .none ? 1 : 0)
            }
            .tint(styleSheet.colors.primary)
        }
        .environment(\.namespace, namespace)
        .environment(\.appRouter, router)
    }
}

