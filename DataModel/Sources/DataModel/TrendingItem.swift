import Foundation

public enum TrendingItem: Sendable {
    case movie(Movie)
    case tvShow(TVShow)

    enum TrendingMediaType: String, Decodable {
        case movie
        case tv
    }
    
    public var media: any Media {
        switch self {
        case .movie(let movie):
            return movie
        case .tvShow(let tvShow):
            return tvShow
        }
    }
}
