import TMDBRepository

enum MediaCategory: Identifiable {
    case popular(MediaList)
    case nowPlaying(MediaList)
    case upcoming(MediaList)
    case topRated(MediaList)
    
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
    
    var mediaList: MediaList {
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
    
    var title: String {
        switch self {
        case .popular:
            "Popular"
        case .nowPlaying:
            "Now Playing"
        case .upcoming:
            "Upcoming"
        case .topRated:
            "Top Rated"
        }
    }
}
