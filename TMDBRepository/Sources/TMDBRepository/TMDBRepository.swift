import Foundation

/// Represents errors that can occur when interacting with the TMDB repository.
public enum TMDBRepositoryError: Error {
    /// Indicates an error occurred during authentication.
    case authenticationError(Error)
}

/// An interface that defines methods to fetch various types of media and trending content from TMDB.
///
/// All methods are asynchronous and can throw errors conforming to `TMDBRepositoryError`.
public protocol TMDBRepository: Sendable {
    /// Fetches a paginated list of movies currently playing in theaters.
    /// - Parameter page: The page number to retrieve.
    /// - Returns: A `MediaList` containing now playing movies.
    /// - Throws: `TMDBRepositoryError` on failure.
    func nowPlayingMovies(page: Int) async throws -> MediaList

    /// Fetches a paginated list of popular movies.
    /// - Parameter page: The page number to retrieve.
    /// - Returns: A `MediaList` containing popular movies.
    /// - Throws: `TMDBRepositoryError` on failure.
    func popularMovies(page: Int) async throws -> MediaList

    /// Fetches a paginated list of popular TV shows.
    /// - Parameter page: The page number to retrieve.
    /// - Returns: A `MediaList` containing popular TV shows.
    /// - Throws: `TMDBRepositoryError` on failure.
    func popularTvShows(page: Int) async throws -> MediaList

    /// Fetches a paginated list of top rated movies.
    /// - Parameter page: The page number to retrieve.
    /// - Returns: A `MediaList` containing top rated movies.
    /// - Throws: `TMDBRepositoryError` on failure.
    func topRatedMovies(page: Int) async throws -> MediaList

    /// Fetches a paginated list of upcoming movies.
    /// - Parameter page: The page number to retrieve.
    /// - Returns: A `MediaList` containing upcoming movies.
    /// - Throws: `TMDBRepositoryError` on failure.
    func upcomingMovies(page: Int) async throws -> MediaList

    /// Fetches a paginated list of trending media for today.
    /// - Parameter page: The page number to retrieve.
    /// - Returns: A `TrendingList` of trending content.
    /// - Throws: `TMDBRepositoryError` on failure.
    func trendingToday(page: Int) async throws -> TrendingList

    /// Provides a builder for constructing URLs to TMDB images (e.g., poster or backdrop images).
    /// - Returns: A `TMDBImageURLBuilder` instance for building image URLs.
    func imageURLBuilder() async -> TMDBImageURLBuilder
}
