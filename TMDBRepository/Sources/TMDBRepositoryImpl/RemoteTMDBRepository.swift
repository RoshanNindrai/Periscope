import AuthenticationServices
import TMDBRepository
import Networking

public struct RemoteTMDBRepository: TMDBRepository {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetchRequestToken() async throws -> RequestToken {
        do {
            let requestTokenResponse: NetworkResponse<RequestTokenResponse> = try await networkService.perform(
                apiRequest: TMDBAPI.requestToken
            )
            return requestTokenResponse.resource.toDomainModel()
        } catch {
            throw TMDBRepositoryError.authenticationError(error)
        }
    }
    
    public func sessionToken(requestToken: String) async throws -> SessionToken {
        let authURL = TMDBAPI.authorizeToken(requestToken: requestToken).toURLRequest().url!
        // TODO: Replace "yourapp" with your app's actual custom URL scheme
        let callbackURLScheme = "yourapp"

        // Bridge callback-based API to async/await
        let returnedURL: URL = try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackURLScheme) { callbackURL, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let callbackURL = callbackURL else {
                    continuation.resume(throwing: TMDBRepositoryError.authenticationError(NSError(domain: "ASWebAuthenticationSession", code: 0, userInfo: [NSLocalizedDescriptionKey: "No callback URL received."])))
                    return
                }
                continuation.resume(returning: callbackURL)
            }
            session.presentationContextProvider = nil // You may need to provide a context in a real app
            session.start()
        }

        // Optionally, you might extract the request_token from returnedURL if TMDB provides it
        // For now, reuse the original requestToken
        do {
            let response: NetworkResponse<SessionResponse> = try await networkService.perform(apiRequest: TMDBAPI.createSession(requestToken: requestToken))
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

private extension SessionResponse {
    func toDomainModel() -> SessionToken {
        .init(success: success, sessionId: sessionId)
    }
}
