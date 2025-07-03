import Networking
import TMDBRepository
import TMDBService

public struct AppServiceContainer: Sendable  {
    public let tmdbRAuthenticationService: TMDBAuthenticationService
    public let networkService: NetworkService
    
    init(
        tmdbRAuthenticationService: TMDBAuthenticationService,
        networkService: NetworkService
    ) {
        self.tmdbRAuthenticationService = tmdbRAuthenticationService
        self.networkService = networkService
    }
}
