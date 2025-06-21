import TMDBRepository
import Networking

public struct DefaultTMDBRepository: TMDBRepository {

    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func nowPlayingMovies() async throws -> MovieList {
        try await fetchMovies(for: .nowPlayingMovies)
    }
    
    public func popularMovies() async throws -> MovieList {
        try await fetchMovies(for: .popularMovies)
    }
    
    public func topRatedMovies() async throws -> MovieList {
        try await fetchMovies(for: .topRatedMovies)
    }
    
    public func upcomingMovies() async throws -> MovieList {
        try await fetchMovies(for: .upcomingMovies)
    }
    
    private func fetchMovies(for request: TMDBAPI) async throws -> MovieList {
        let movieList: NetworkResponse<MovieListResponse> = try await networkService.perform(apiRequest: request)
        return movieList.resource.toDomainModel()
    }
}

// MARK: - helpers

extension MovieListResponse {
    func toDomainModel() -> MovieList {
        .init(
            movies: results.map { $0.toDomainModel() },
            page: page,
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}

extension MovieResponse {
    func toDomainModel() -> Movie {
        Movie(
            adult: adult,
            backdropPath: backdropPath,
            genreIds: genreIds,
            id: id,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}
