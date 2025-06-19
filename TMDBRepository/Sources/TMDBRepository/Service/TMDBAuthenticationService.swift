import Foundation

/// Defines the contract for interacting with TMDB Authentication endpoints.
public protocol TMDBAuthenticationService: Sendable {
    /// Fetches a new request token from TMDB for starting an authentication session.
    func requestToken() async throws -> RequestToken
    /// Exchanges a request token for a session token, enabling authenticated requests.
    func sessionToken(requestToken: String) async throws -> SessionToken
}
