import Foundation

/// Represents either a Movie or TV Show, each carrying its unique identifier.
public enum MediaItemType: Sendable, Equatable {
    case movie
    case tvShow
    
    public var description: String {
        switch self {
        case .movie:
            return "Movie"
        case .tvShow:
            return "Tv Show"
        }
    }
}

public protocol Media: Equatable, Sendable {
    var id: Int { get }
    var title: String { get }
    var type: MediaItemType { get }
    var overview: String { get }
    var releaseDate: String { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }
}

public extension Media {
    var releaseYear: String {
        String(releaseDate.prefix(4))
    }
}
