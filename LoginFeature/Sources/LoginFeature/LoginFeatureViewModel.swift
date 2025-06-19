import TMDBRepository
import SwiftUI
import Combine

@Observable
public final class LoginFeatureViewModel {
    
    private let tmdbRepository: TMDBRepositoryProtocol

    public init(tmdbRepository: TMDBRepositoryProtocol) {
        self.tmdbRepository = tmdbRepository
    }

    enum State {
        case initialized
        case fetchedRequestToken(RequestToken)
        case requestingUserPermissions
        case fetchedAccessToken
        case fetchingAccessToken
        case failed(Error)
    }
    
    enum Action {
        case fetchRequestToken
        case signInButtonTapped
    }
    
    private(set) var state: State = .initialized
    
    func reduce(_ action: Action) async throws {
        switch action {
        case .fetchRequestToken:
            let requestToken = try await tmdbRepository.fetchRequestToken()
            state = .fetchedRequestToken(requestToken)
            
        case .signInButtonTapped:
            guard case let .fetchedRequestToken(requestToken) = state else {
                try await reduce(.fetchRequestToken)
                return
            }
            
            state = .requestingUserPermissions
            let _ = try await tmdbRepository.sessionToken(requestToken: requestToken.requestToken)
            state = .fetchedAccessToken
        }
    }
}
