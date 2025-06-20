import Networking
import TMDBRepository
import TMDBRepositoryImpl

public struct DefaultTMDBRepositoryFactoryDependencies: TMDBRepositoryFactoryDependencies {
    public let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

public struct DefaultTMDBRepositoryFactory: TMDBRepositoryFactory {
    private let dependencies: TMDBRepositoryFactoryDependencies
    
    public init(dependencies: TMDBRepositoryFactoryDependencies) {
        self.dependencies = dependencies
    }
    
    public func makeAuthenticationService() -> any TMDBAuthenticationService {
        RemoteTMDBAuthenticationService(
            networkService: dependencies.networkService
        )
    }
}
