import Foundation

public enum TMDBRepositoryError: Error {
    case authenticationError(Error)
}

public protocol TMDBRepository: Sendable {
    func nowPlayingMovies() async throws -> MovieList
    func popularMovies() async throws -> MovieList
    func topRatedMovies() async throws -> MovieList
    func upcomingMovies() async throws -> MovieList
}
