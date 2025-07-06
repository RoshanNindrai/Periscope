import Foundation

public enum SearchItem: Equatable, Sendable {
    case movie(Movie)
    case tvShow(TVShow)
    case person(Person)

    public var id: Int {
        switch self {
        case .movie(let movie): return movie.id
        case .tvShow(let tvShow): return tvShow.id
        case .person(let person): return person.id
        }
    }
    
    public var media: (any Media)? {
        switch self {
        case .movie(let movie):
            return movie
        case .tvShow(let tvShow):
            return tvShow
        case .person:
            return nil
        }
    }
}

public struct SearchResultSet: Equatable, Sendable {
    public let page: Int
    public let items: [SearchItem]
    public let totalPages: Int
    public let totalResults: Int

    public init(page: Int, items: [SearchItem], totalPages: Int, totalResults: Int) {
        self.page = page
        self.items = items
        self.totalPages = totalPages
        self.totalResults = totalResults
    }

    public static func == (lhs: SearchResultSet, rhs: SearchResultSet) -> Bool {
        lhs.page == rhs.page &&
        lhs.totalPages == rhs.totalPages &&
        lhs.totalResults == rhs.totalResults &&
        lhs.items.count == rhs.items.count &&
        zip(lhs.items, rhs.items).allSatisfy { $0.id == $1.id }
    }
}
