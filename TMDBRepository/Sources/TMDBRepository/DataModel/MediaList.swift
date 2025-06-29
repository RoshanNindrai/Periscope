import Foundation

public protocol PageableMediaList {
    var items: [any Media] { get }
    var page: Int { get }
    var totalPages: Int { get }
}

public struct MediaList: PageableMediaList, Sendable {
    public let items: [any Media]
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
    
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
