import Foundation

public enum MediaCategory: Identifiable, Equatable {
    case popularMovies(MediaList)
    case nowPlaying(MediaList)
    case upcoming(MediaList)
    case popularTVShows(MediaList)
    case topRated(MediaList)
    case trendingToday(TrendingList)
    
    public var id: String {
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
    
    public var pageableMediaList: any PageableMediaList {
        switch self {
        case .popularMovies(let list):
            return list
        case .nowPlaying(let list):
            return list
        case .upcoming(let list):
            return list
        case .popularTVShows(let list):
            return list
        case .topRated(let list):
            return list
        case .trendingToday(let list):
            return list
        }
    }
    
    public var mediaItems: [any Media] {
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
            return list.items
        }
    }
    
    public var title: String {
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
    
    public static func == (lhs: MediaCategory, rhs: MediaCategory) -> Bool {
        switch (lhs, rhs) {
        case let (.popularMovies(l), .popularMovies(r)):
            return l == r
        case let (.nowPlaying(l), .nowPlaying(r)):
            return l == r
        case let (.upcoming(l), .upcoming(r)):
            return l == r
        case let (.popularTVShows(l), .popularTVShows(r)):
            return l == r
        case let (.topRated(l), .topRated(r)):
            return l == r
        case let (.trendingToday(l), .trendingToday(r)):
            return l == r
        default:
            return false
        }
    }
}
