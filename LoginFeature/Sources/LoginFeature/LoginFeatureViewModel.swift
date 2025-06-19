import TMDBRepository
import SwiftUI
import Combine

@MainActor @Observable
public final class LoginFeatureViewModel {
    
    private let authenticationService: TMDBAuthenticationService

    public init(authenticationService: TMDBAuthenticationService) {
        self.authenticationService = authenticationService
    }

    enum State {
        case initialized
        case loading
        case fetchedRequestToken(RequestToken)
        case requestingUserPermissions
        case fetchedAccessToken
        case failed(Error)
    }
    
    enum Action {
        case fetchRequestToken
        case signInButtonTapped
    }
    
    private(set) var state: State = .initialized
    
    func reduce(_ action: Action) async {
        do {
            switch action {
            case .fetchRequestToken:
                state = .loading
                let requestToken = try await authenticationService.requestToken()
                state = .fetchedRequestToken(requestToken)
                
            case .signInButtonTapped:
                guard case let .fetchedRequestToken(requestToken) = state else {
                    await reduce(.fetchRequestToken)
                    return
                }
                state = .requestingUserPermissions
                let _ = try await authenticationService.sessionToken(
                    requestToken: requestToken.requestToken
                )
                state = .fetchedAccessToken
            }
        } catch {
            state = .failed(error)
        }
    }
}
