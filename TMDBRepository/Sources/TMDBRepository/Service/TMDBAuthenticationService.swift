import Foundation

/// Defines the contract for interacting with TMDB Authentication endpoints, without UI side-effects.
public protocol TMDBAuthenticationService: Sendable {
    /// Fetches a new request token from TMDB for starting an authentication session.
    func requestToken() async throws -> RequestToken

    /// Returns the authorization URL where the user should be sent to approve the request token.
    func authorizationURL(for requestToken: String) -> URL

    /// Exchanges an approved request token for a session token.
    func sessionToken(requestToken: String) async throws -> SessionToken
    
    /// Returns true, if there is an active session
    func haveAnActiveSession() -> Bool
}
