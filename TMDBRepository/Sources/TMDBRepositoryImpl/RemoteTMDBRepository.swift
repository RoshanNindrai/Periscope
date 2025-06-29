import Foundation
import Networking
import TMDBRepository

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
    
    public func nowPlayingMovies() async throws -> MediaList {
        try await fetchMovies(for: .nowPlayingMovies)
    }
    
    public func popularMovies() async throws -> MediaList {
        try await fetchMovies(for: .popularMovies)
    }
    
    public func popularTvShows() async throws -> MediaList {
        try await fetchTVShows(for: .popularTVShows)
    }
    
    public func topRatedMovies() async throws -> MediaList {
        try await fetchMovies(for: .topRatedMovies)
    }
    
    public func upcomingMovies() async throws -> MediaList {
        try await fetchMovies(for: .upcomingMovies)
    }
    
    public func trendingToday() async throws -> TrendingList {
        try await fetchTrendingItems(for: .trendingToday)
    }
    
    private func fetchMovies(for request: TMDBAPI) async throws -> MediaList {
        let mediaList: NetworkResponse<MovieListResponse> = try await networkService.perform(apiRequest: request)
        return mediaList.resource.toDomainModel()
    }

    private func fetchTVShows(for request: TMDBAPI) async throws -> MediaList {
        let mediaList: NetworkResponse<TVShowListResponse> = try await networkService.perform(apiRequest: request)
        return mediaList.resource.toDomainModel()
    }
    
    private func fetchTrendingItems(for request: TMDBAPI) async throws -> TrendingList {
        let mediaList: NetworkResponse<TrendingListResponse> = try await networkService.perform(apiRequest: request)
        return mediaList.resource.toDomainModel()
    }
}
