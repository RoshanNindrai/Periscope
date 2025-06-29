import SwiftUI
import TMDBRepository

@MainActor
@Observable
public final class HomeFeatureViewModel {
    enum Output {
        case loading
        case fetched([MediaCategory])
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
            async let popularMovies: MediaCategory? = try? .popularMovies(repository.popularMovies())
            async let trendingToday: MediaCategory? = try? .trendingToday(repository.trendingToday())
            async let upcomingMovies: MediaCategory? = try? .upcoming(repository.upcomingMovies())
            async let popularTVShows: MediaCategory? = try! .popularTVShows(repository.popularTvShows())
            async let topRatedMovies: MediaCategory? = try? .topRated(repository.topRatedMovies())
            async let nowPlayingMovies: MediaCategory? = try? .nowPlaying(repository.nowPlayingMovies())
            
            let result: [MediaCategory] = await [
                trendingToday,
                nowPlayingMovies,
                upcomingMovies,
                popularTVShows,
                popularMovies,
                topRatedMovies
            ].compactMap { $0 }

            output = .fetched(result)
        }
    }
}
