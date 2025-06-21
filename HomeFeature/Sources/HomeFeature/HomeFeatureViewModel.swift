import SwiftUI
import TMDBRepository

enum MovieCategory: Identifiable {
    case popular(MovieList)
    case nowPlaying(MovieList)
    case upcoming(MovieList)
    case topRated(MovieList)
    
    var id: String {
        switch self {
        case .popular:
            "popular"
        case .nowPlaying:
            "nowPlaying"
        case .upcoming:
            "upcoming"
        case .topRated:
            "topRated"
        }
    }
    
    var movieList: MovieList {
        switch self {
        case .popular(let list):
            return list
        case .nowPlaying(let list):
            return list
        case .upcoming(let list):
            return list
        case .topRated(let list):
            return list
        }
    }
}

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
                async let popularMovies = try await repository.popularMovies()
                async let upcomingMovies = try await repository.upcomingMovies()
                async let topRatedMovies = try await repository.topRatedMovies()
                async let nowPlayingMovies = try await repository.nowPlayingMovies()
                
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
