import Networking
import TMDBRepository
import TMDBRepositoryImpl
import TMDBService
import Utils

public struct DefaultTMDBRepositoryFactoryDependencies: TMDBRepositoryFactoryDependencies {
    public let networkService: NetworkService
    public let keychainStore: KeychainStore
    
    public init(networkService: NetworkService, keychainStore: KeychainStore) {
        self.networkService = networkService
        self.keychainStore = keychainStore
    }
}

public struct DefaultTMDBRepositoryFactory: TMDBRepositoryFactory {
    private let dependencies: TMDBRepositoryFactoryDependencies
    
    public init(dependencies: TMDBRepositoryFactoryDependencies) {
        self.dependencies = dependencies
    }
    
    public func makeAuthenticationService() -> any TMDBAuthenticationService {
        RemoteTMDBAuthenticationService(
            networkService: dependencies.networkService,
            keychainStore: dependencies.keychainStore
        )
    }
    
    public func makeRepository() -> any TMDBRepository {
        RemoteTMDBRepository(networkService: dependencies.networkService)
    }
}
