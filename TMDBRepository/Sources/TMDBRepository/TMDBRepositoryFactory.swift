import Networking

public protocol TMDBRepositoryFactoryDependencies {
    var networkService: NetworkService { get }
}

public protocol TMDBRepositoryFactory {
    func makeAuthenticationService() -> TMDBAuthenticationService
}
