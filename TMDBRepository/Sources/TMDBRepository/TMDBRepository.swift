import DataModel
import TMDBService
import Foundation

/// Represents either a Movie or TV Show, each carrying its unique identifier.
public enum MediaItem: Sendable, Equatable {
    case movie(id: Int)
    case tvShow(id: Int)
}

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
    func trendingToday(page: Int) async throws -> TrendingMediaList
    
    /// Fetches a list of movies related to the specified movie.
    /// - Parameter movieId: The identifier of the movie for which to find related movies.
    /// - Returns: A `MediaList` containing movies related to the given movie.
    /// - Throws: `TMDBRepositoryError` on failure.
    func relatedMedia(for mediaItem: MediaItem) async throws -> MediaList

    /// Fetches the cast and crew information for a specified media item (either a movie or TV show).
    /// - Parameter mediaItem: The media item (movie or TV show) for which to retrieve the cast and crew.
    /// - Returns: A `CastList` containing the cast and crew details.
    /// - Throws: `TMDBRepositoryError` on failure.
    func castAndCrewList(for mediaItem: MediaItem) async throws -> CastAndCrewList
    
    /// Fetches the detailed information for a specified media item (either a movie or TV show).
    /// - Parameter mediaItem: The media item (movie or TV show) for which to retrieve detailed information.
    /// - Returns: An object conforming to `MediaDetail` containing the detailed information.
    /// - Throws: `TMDBRepositoryError` on failure.
    func mediaDetail(for mediaItem: MediaItem) async throws -> any MediaDetail
    
    /// Searches for media items (movies or TV shows) matching the specified query string.
    /// - Parameter query: The text to search for.
    /// - Returns: A `MediaList` containing the search results.
    /// - Throws: `TMDBRepositoryError` on failure.
    func search(for query: String) async throws -> SearchResultSet

    /// Provides a builder for constructing URLs to TMDB images (e.g., poster or backdrop images).
    /// - Returns: A `TMDBImageURLBuilder` instance for building image URLs.
    func imageURLBuilder() async -> TMDBImageURLBuilder
}

