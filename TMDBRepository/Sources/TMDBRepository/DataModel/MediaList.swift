import Foundation

/// Protocol for paginated lists of media items, such as movies or TV shows.
/// Types conforming to this protocol provide access to the items on the current page and pagination metadata.
///
/// - items: The media items on this page.
/// - page: The current page index (1-based).
/// - totalPages: The total number of available pages.
public protocol PageableMediaList {
    var items: [any Media] { get }
    var page: Int { get }
    var totalPages: Int { get }
}

/// Concrete implementation of PageableMediaList for paginated movie or TV show results.
/// Includes total result count for the query, in addition to basic pagination.
public struct MediaList: PageableMediaList, Sendable {
    /// The items on this page.
    public let items: [any Media]
    /// The current page index (1-based).
    public let page: Int
    /// The total number of available pages.
    public let totalPages: Int
    /// The total number of results for this query across all pages.
    public let totalResults: Int
    
    /// Creates a new MediaList.
    /// - Parameters:
    ///   - medias: The media items on this page.
    ///   - page: The current page index.
    ///   - totalPages: Total page count available.
    ///   - totalResults: Total result count available.
    public init(
        medias: [any Media],
        page: Int,
        totalPages: Int,
        totalResults: Int
    ) {
        self.items = medias
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
