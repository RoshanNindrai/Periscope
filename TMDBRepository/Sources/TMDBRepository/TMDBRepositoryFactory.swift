import Networking
import TMDBService
import Utils

public protocol TMDBRepositoryFactoryDependencies: Sendable  {
    var networkService: NetworkService { get }
    var keychainStore: KeychainStore { get }
}

public protocol TMDBRepositoryFactory: Sendable  {
    func makeAuthenticationService() -> TMDBAuthenticationService
    func makeRepository() -> TMDBRepository
}
