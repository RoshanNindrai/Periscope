import DataModel
import Foundation
import Networking
import TMDBRepository
import TMDBService

actor TMDBConfigurationCache {
    private var config: TMDBConfiguration
    
    init() {
        self.config = TMDBConfiguration.default
    }

    func get() -> TMDBConfiguration {
        config
    }

    func update(with newConfig: TMDBConfiguration) {
        config = newConfig
    }
}

public struct RemoteTMDBRepository: TMDBRepository {

    private let networkService: NetworkService
    private let configCache: TMDBConfigurationCache
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
        self.configCache = TMDBConfigurationCache()
    }

    public func nowPlayingMovies(page: Int = .zero) async throws -> MediaList {
        try await fetchMovies(for: .nowPlayingMovies)
    }
    
    public func popularMovies(page: Int = .zero) async throws -> MediaList {
        try await fetchMovies(for: .popularMovies)
    }
    
    public func popularTvShows(page: Int = .zero) async throws -> MediaList {
        try await fetchTVShows(for: .popularTVShows)
    }
    
    public func topRatedMovies(page: Int = .zero) async throws -> MediaList {
        try await fetchMovies(for: .topRatedMovies)
    }
    
    public func upcomingMovies(page: Int = .zero) async throws -> MediaList {
        try await fetchMovies(for: .upcomingMovies)
    }
    
    public func trendingToday(page: Int = .zero) async throws -> TrendingList {
        try await fetchTrendingItems(for: .trendingToday)
    }
    
    public func imageURLBuilder() async -> TMDBImageURLBuilder {
        let request = TMDBAPI.configuration
        do {
            let configuration: NetworkResponse<TMDBConfigurationResponse> = try await networkService.perform(apiRequest: request)
            let configurationDomainModel = configuration.resource.toDomainModel()
            await configCache.update(with: configurationDomainModel)
            
            return TMDBImageURLBuilder(configuration: configurationDomainModel)
        } catch {
            return TMDBImageURLBuilder(configuration: .default)
        }
    }
}


// MARK: - private helpers

private extension RemoteTMDBRepository {
    func fetchMovies(for request: TMDBAPI) async throws -> MediaList {
        let mediaList: NetworkResponse<MovieListResponse> = try await networkService.perform(apiRequest: request)
        return mediaList.resource.toDomainModel()
    }

    func fetchTVShows(for request: TMDBAPI) async throws -> MediaList {
        let mediaList: NetworkResponse<TVShowListResponse> = try await networkService.perform(apiRequest: request)
        return mediaList.resource.toDomainModel()
    }
    
    func fetchTrendingItems(for request: TMDBAPI) async throws -> TrendingList {
        let mediaList: NetworkResponse<TrendingListResponse> = try await networkService.perform(apiRequest: request)
        return mediaList.resource.toDomainModel()
    }
}
