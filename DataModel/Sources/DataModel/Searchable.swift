import Foundation

/// Represents either a Movie or TV Show, each carrying its unique identifier.
public enum SearchItemType: Sendable, Equatable {
    case movie
    case tvShow
    case person
}

public protocol Searchable: Equatable, Sendable {
    var id: Int { get }
    var title: String { get }
    var searchItemType: SearchItemType { get }
    var subtitle: String { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }
}
