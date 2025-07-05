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
    
    public func mediaDetail(for mediaItem: MediaItem) async throws -> any MediaDetail {
        switch mediaItem {
        case .movie(let id):
            try await fetchMovieDetail(for: .movieDetails(id: id))
        case .tvShow(let id):
            try await fetchShowDetail(for: .tvDetails(id: id))
        }
    }
    
    public func relatedMedia(for mediaItem: MediaItem) async throws -> MediaList {
        switch mediaItem {
        case .movie(let id):
            try await fetchMovies(for: .relatedMovies(id: id))
        case .tvShow(let id):
            try await fetchTVShows(for: .relatedTVShows(id: id))
        }
    }
    
    public func castAndCrewList(for mediaItem: MediaItem) async throws -> CastList {
        switch mediaItem {
        case .movie(let id):
            try await fetchCastAndCrew(for: .movieCredits(id: id))
        case .tvShow(let id):
            try await fetchCastAndCrew(for: .tvCredits(id: id))
        }
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
    
    func fetchCastAndCrew(for request: TMDBAPI) async throws -> CastList {
        let mediaList: NetworkResponse<CastListResponse> = try await networkService.perform(apiRequest: request)
        return mediaList.resource.toDomainModel()
    }
    
    func fetchMovieDetail(for request: TMDBAPI) async throws -> any MediaDetail {
        let movieDetail: NetworkResponse<MovieDetailResponse> = try await networkService.perform(apiRequest: request)
        return movieDetail.resource.toDomainModel()
    }
    
    func fetchShowDetail(for request: TMDBAPI) async throws -> any MediaDetail {
        let showDetail: NetworkResponse<ShowDetailResponse> = try await networkService.perform(apiRequest: request)
        return showDetail.resource.toDomainModel()
    }
}
