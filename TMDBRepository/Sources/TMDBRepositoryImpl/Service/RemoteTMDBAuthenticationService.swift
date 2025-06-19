import TMDBRepository
import Networking
import UIKit

public struct RemoteTMDBAuthenticationService: TMDBAuthenticationService {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func requestToken() async throws -> RequestToken {
        do {
            let requestTokenResponse: NetworkResponse<RequestTokenResponse> = try await networkService.perform(
                apiRequest: TMDBAPI.requestToken
            )
            return requestTokenResponse.resource.toDomainModel()
        } catch {
            throw TMDBRepositoryError.authenticationError(error)
        }
    }
    
    public func authorizationURL(for requestToken: String) -> URL {
        return TMDBAPI.authorizeToken(requestToken: requestToken).toURLRequest().url!
    }

    public func sessionToken(requestToken: String) async throws -> SessionToken {
        // Optionally, you might extract the request_token from returnedURL if TMDB provides it
        // For now, reuse the original requestToken
        do {
            let response: NetworkResponse<SessionTokenResponse> = try await networkService.perform(
                apiRequest: TMDBAPI.createSession(requestToken: requestToken)
            )
            return response.resource.toDomainModel()
        } catch {
            throw TMDBRepositoryError.authenticationError(error)
        }
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
