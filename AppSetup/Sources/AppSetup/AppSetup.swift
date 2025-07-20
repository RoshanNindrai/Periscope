import Networking
import NetworkingFactory
import SwiftUI
import TMDBRepository
import TMDBRepositoryFactory
import Utils
import UtilsFactory

public struct AppSetupDependencies: Sendable {
    let networkServiceFactory: NetworkServiceFactory
    let tmdbRepositoryFactory: TMDBRepositoryFactory
    let countryCodeProviderFactory: CountryCodeProviderFactory
    
    let keychainStore = KeychainStore(service: "com.periscope.keychain")
    
    public init() {
        networkServiceFactory = DefaultNetworkServiceFactory()
        countryCodeProviderFactory = DefaultCountryCodeProviderFactory()
        
        tmdbRepositoryFactory = DefaultTMDBRepositoryFactory(
            dependencies: DefaultTMDBRepositoryFactoryDependencies(
                networkService: networkServiceFactory.makeNetworkService(),
                keychainStore: keychainStore
            )
        )
    }
}

public struct RepositoryContainer: Sendable {
    public let tmdbRepository: TMDBRepository
    
    public init(tmdbRepository: TMDBRepository) {
        self.tmdbRepository = tmdbRepository
    }
}

public struct PeriscopeAppSetup: Sendable  {
    public let serviceContainer: AppServiceContainer
    public let repositoryContainer: RepositoryContainer
    public let keychainStore: KeychainStore
    public let countryCodeProvider: CountryCodeProviding
    
    private let dependencies: AppSetupDependencies
    
    public init(dependencies: AppSetupDependencies) {
        self.dependencies = dependencies
        
        keychainStore = dependencies.keychainStore
        
        serviceContainer = AppServiceContainer(
            tmdbRAuthenticationService: dependencies.tmdbRepositoryFactory.makeAuthenticationService(),
            networkService: dependencies.networkServiceFactory.makeNetworkService()
        )
        
        repositoryContainer = RepositoryContainer(
            tmdbRepository: dependencies.tmdbRepositoryFactory.makeRepository()
        )
        
        countryCodeProvider = dependencies.countryCodeProviderFactory.makeCountryCodeProvider()
    }
}

// MARK: Environment dependencies

public struct AppSetupEnvironmentKey: EnvironmentKey {
    public static let defaultValue: PeriscopeAppSetup = PeriscopeAppSetup(dependencies: .init())
}

public extension EnvironmentValues {
    var appSetup: PeriscopeAppSetup {
        get {
            self[AppSetupEnvironmentKey.self]
        } set {
            self[AppSetupEnvironmentKey.self] = newValue
        }
    }
}
