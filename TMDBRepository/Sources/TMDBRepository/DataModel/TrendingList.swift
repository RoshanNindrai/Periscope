import Foundation

public struct TrendingList: PageableMediaList, Sendable {
    public let page: Int
    public let items: [any Media]
    public let totalPages: Int
    public let totalResults: Int
    
    public init(page: Int, items: [TrendingItem], totalPages: Int, totalResults: Int) {
        self.page = page
        self.items = items.map(\.media)
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
