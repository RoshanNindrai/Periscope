import Networking
import NetworkingFactory
import SwiftUI
import TMDBRepository
import TMDBRepositoryFactory

public struct AppSetupDependencies: Sendable {
    let networkServiceFactory: NetworkServiceFactory
    let tmdbRepositoryFactory: TMDBRepositoryFactory
    
    fileprivate init() {
        networkServiceFactory = DefaultNetworkServiceFactory()
        tmdbRepositoryFactory = DefaultTMDBRepositoryFactory(
            dependencies: DefaultTMDBRepositoryFactoryDependencies(
                networkService: networkServiceFactory.makeNetworkService()
            )
        )
    }
}

public struct PeriscopeAppSetup: Sendable  {
    public let serviceContainer: AppServiceContainer
    private let dependencies: AppSetupDependencies
    
    public init(dependencies: AppSetupDependencies) {
        self.dependencies = dependencies
        serviceContainer = AppServiceContainer(
            tmdbRAuthenticationService: dependencies.tmdbRepositoryFactory.makeAuthenticationService(),
            networkService: dependencies.networkServiceFactory.makeNetworkService()
        )
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
