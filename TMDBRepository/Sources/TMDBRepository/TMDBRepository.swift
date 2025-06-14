// Import Foundation framework for core data types and networking support
import Foundation

public typealias TMDBRepository = TMDBAuthenticationRepository

/// Defines the contract for interacting with TMDB Authentication endpoints.
public protocol TMDBAuthenticationRepository {
    /// Fetches a new request token from TMDB for starting an authentication session.
    func fetchRequestToken() async throws -> RefreshToken
    /// Exchanges a request token for a session token, enabling authenticated requests.
    func sessionToken(requestToken: String) async throws -> SessionToken
}
