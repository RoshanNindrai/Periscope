import DataModel
import SwiftUI
import TMDBRepository
import Utils

@MainActor
@Observable
public final class HomeFeatureViewModel {
    enum Output {
        case loading
        case fetched([MediaCategory])
        case failed(Error)
    }
    
    enum Action {
        case requestForLocationPermission
        case fetchLatest
    }
    
    private(set) var output: Output = .loading
    
    private let repository: TMDBRepository
    private let countryCodeProvider: CountryCodeProviding
    
    public init(repository: TMDBRepository, countryCodeProvider: CountryCodeProviding) {
        self.repository = repository
        self.countryCodeProvider = countryCodeProvider
    }

    func reduce(_ action: Action) async {
        switch action {
        
        case .requestForLocationPermission:
            countryCodeProvider.requestForPermission()
            
        case .fetchLatest:
            async let popularMovies: MediaCategory? = try? .popularMovies(repository.popularMovies(page: .zero))
            async let trendingToday: MediaCategory? = try? .trendingToday(repository.trendingToday(page: .zero))
            async let upcomingMovies: MediaCategory? = try? .upcoming(repository.upcomingMovies(page: .zero))
            async let popularTVShows: MediaCategory? = try? .popularTVShows(repository.popularTvShows(page: .zero))
            async let topRatedMovies: MediaCategory? = try? .topRated(repository.topRatedMovies(page: .zero))
            async let nowPlayingMovies: MediaCategory? = try? .nowPlaying(repository.nowPlayingMovies(page: .zero))
            
            let result: [MediaCategory] = await [
                trendingToday,
                nowPlayingMovies,
                upcomingMovies,
                popularTVShows,
                popularMovies,
                topRatedMovies
            ].compactMap { $0 }

            withAnimation(.easeOut) {
                output = .fetched(result)
            }
        }
    }
}
