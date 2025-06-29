import Foundation

public enum TMDBRepositoryError: Error {
    case authenticationError(Error)
}

public protocol TMDBRepository: Sendable {
    func nowPlayingMovies() async throws -> MediaList
    func popularMovies() async throws -> MediaList
    func popularTvShows() async throws -> MediaList
    func topRatedMovies() async throws -> MediaList
    func upcomingMovies() async throws -> MediaList
    
    func trendingToday() async throws -> TrendingList
    
    func imageURLBuilder() async -> TMDBImageURLBuilder
}
