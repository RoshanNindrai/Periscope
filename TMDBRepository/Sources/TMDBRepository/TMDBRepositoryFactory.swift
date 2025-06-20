import Networking

public protocol TMDBRepositoryFactoryDependencies: Sendable  {
    var networkService: NetworkService { get }
}

public protocol TMDBRepositoryFactory: Sendable  {
    func makeAuthenticationService() -> TMDBAuthenticationService
}
