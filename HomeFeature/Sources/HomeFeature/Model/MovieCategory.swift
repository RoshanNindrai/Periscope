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
