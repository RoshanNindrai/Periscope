import AuthenticationServices
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
    
    public func sessionToken(requestToken: String) async throws -> SessionToken {
        let authorizeTokenRequest = TMDBAPI.authorizeToken(requestToken: requestToken).toURLRequest()
        let callbackURLScheme = "periscope"
        
        let provider = await MainActor.run {
            BasicPresentationContextProvider()
        }

        let _: URL = try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(
                url: authorizeTokenRequest.url!,
                callbackURLScheme: callbackURLScheme
            ) { callbackURL, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let callbackURL = callbackURL else {
                    continuation.resume(
                        throwing: TMDBRepositoryError.authenticationError(
                            NSError(
                                domain: "ASWebAuthenticationSession",
                                code: 0,
                                userInfo: [
                                    NSLocalizedDescriptionKey: "No callback URL received."
                                ]
                            )
                        )
                    )
                    return
                }

                continuation.resume(returning: callbackURL)
            }

            Task { @MainActor in
                session.presentationContextProvider = provider
                session.start()
            }
        }

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

@MainActor
private final class BasicPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("Unable to find a valid key window for ASWebAuthenticationSession.")
        }

        if #available(iOS 26.0, *) {
            return ASPresentationAnchor(windowScene: windowScene)
        } else {
            return keyWindow
        }
    }
}
