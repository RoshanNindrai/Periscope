import Foundation

public enum TMDBRepositoryError: Error {
    case authenticationError(Error)
}

public protocol TMDBRepository: Sendable {
    func nowPlayingMovies(page: Int) async throws -> MediaList
    func popularMovies(page: Int) async throws -> MediaList
    func popularTvShows(page: Int) async throws -> MediaList
    func topRatedMovies(page: Int) async throws -> MediaList
    func upcomingMovies(page: Int) async throws -> MediaList
    
    func trendingToday(page: Int) async throws -> TrendingList
    
    func imageURLBuilder() async -> TMDBImageURLBuilder
}
