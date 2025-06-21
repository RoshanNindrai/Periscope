import Foundation

public struct MovieList: Sendable {
    public let movies: [Movie]
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
    
    public init(
        movies: [Movie],
        page: Int,
        totalPages: Int,
        totalResults: Int
    ) {
        self.movies = movies
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
