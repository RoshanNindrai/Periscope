import Foundation

public struct MediaList: Sendable {
    public let items: [Media]
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
    
    public init(
        movies: [Media],
        page: Int,
        totalPages: Int,
        totalResults: Int
    ) {
        self.items = movies
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
