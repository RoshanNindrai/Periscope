import TMDBRepository

enum MediaCategory: Identifiable {
    case popularMovies(MediaList)
    case nowPlaying(MediaList)
    case upcoming(MediaList)
    case popularTVShows(MediaList)
    case topRated(MediaList)
    case trendingToday(TrendingList)
    
    var id: String {
        switch self {
        case .popularMovies:
            "popularMovies"
        case .nowPlaying:
            "nowPlaying"
        case .upcoming:
            "upcoming"
        case .popularTVShows:
            "popularTVShows"
        case .topRated:
            "topRated"
        case .trendingToday:
            "trendingToday"
        }
    }
    
    var mediaItems: [any Media] {
        switch self {
        case .popularMovies(let list):
            return list.items
        case .nowPlaying(let list):
            return list.items
        case .upcoming(let list):
            return list.items
        case .popularTVShows(let list):
            return list.items
        case .topRated(let list):
            return list.items
        case .trendingToday(let list):
            return list.items.map(\.media)
        }
    }
    
    var title: String {
        switch self {
        case .popularMovies:
            "Popular Movies"
        case .nowPlaying:
            "In Theatres Now"
        case .upcoming:
            "Upcoming Movies"
        case .popularTVShows:
            "Popular TV Shows"
        case .topRated:
            "Top Rated Movies"
        case .trendingToday:
            "Trending Today"
        }
    }
}
