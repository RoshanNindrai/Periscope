import DataModel
import Networking
import TMDBService
import TMDBRepository
import UIKit
import Utils

public struct RemoteTMDBAuthenticationService: TMDBAuthenticationService {
    private let networkService: NetworkService
    private let keychainStore: KeychainStore
    private let sessionIdKeychainKey = "TMDBAuthenticationService.sessionIdKey"
    
    public init(networkService: NetworkService, keychainStore: KeychainStore) {
        self.networkService = networkService
        self.keychainStore = keychainStore
    }
    
    /// Fetches a new request token from TMDB.
    public func requestToken() async throws -> RequestToken {
        do {
            let response: NetworkResponse<RequestTokenResponse> = try await networkService.perform(apiRequest: TMDBAPI.requestToken)
            return response.resource.toDomainModel()
        } catch {
            throw TMDBRepositoryError.authenticationError(error)
        }
    }
    
    /// Returns the URL to authorize the provided request token.
    public func authorizationURL(for requestToken: String) -> URL {
        guard let url = try? TMDBAPI.authorizeToken(requestToken: requestToken).toURLRequest().url else {
            preconditionFailure("Invalid Authorization URL for TMDB!")
        }
        return url
    }

    /// Exchanges an approved request token for a session token and securely saves the session ID.
    public func sessionToken(requestToken: String) async throws -> SessionToken {
        do {
            let response: NetworkResponse<SessionTokenResponse> = try await networkService.perform(apiRequest: TMDBAPI.createSession(requestToken: requestToken))
            let sessionToken = response.resource.toDomainModel()
            keychainStore.set(sessionToken.sessionId, forKey: sessionIdKeychainKey)
            return sessionToken
        } catch {
            throw TMDBRepositoryError.authenticationError(error)
        }
    }
    
    /// Returns true if a session ID is found in the keychain.
    public func haveAnActiveSession() -> Bool {
        keychainStore.string(forKey: sessionIdKeychainKey) != nil
    }
}

// MARK: - Helpers

private extension RequestTokenResponse {
    func toDomainModel() -> RequestToken {
        .init(
            success: success,
            expiresAt: expiresAt,
            requestToken: requestToken
        )
    }
}

private extension SessionTokenResponse {
    func toDomainModel() -> SessionToken {
        .init(success: success, sessionId: sessionId)
    }
}
