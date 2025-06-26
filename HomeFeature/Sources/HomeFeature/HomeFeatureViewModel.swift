import SwiftUI
import TMDBRepository

@MainActor
@Observable
public final class HomeFeatureViewModel {
    enum Output {
        case loading
        case fetched([MovieCategory])
        case failed(Error)
    }
    
    enum Action {
        case fetchLatest
    }
    
    private(set) var output: Output = .loading
    private let repository: TMDBRepository
    
    public init(repository: TMDBRepository) {
        self.repository = repository
    }

    func reduce(_ action: Action) async {
        switch action {
        case .fetchLatest:
            do {
                async let popularMovies = try repository.popularMovies()
                async let upcomingMovies = try repository.upcomingMovies()
                async let topRatedMovies = try repository.topRatedMovies()
                async let nowPlayingMovies = try repository.nowPlayingMovies()
                
                let result: [MovieCategory] = try await [
                    .nowPlaying(nowPlayingMovies),
                    .upcoming(upcomingMovies),
                    .popular(popularMovies),
                    .topRated(topRatedMovies)
                ]

                output = .fetched(result)
            } catch {
                output = .failed(error)
            }
        }
    }
}
