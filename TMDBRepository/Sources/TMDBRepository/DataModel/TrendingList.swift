import Foundation

public struct TrendingList: Sendable {
    public let page: Int
    public let items: [TrendingItem]
    public let totalPages: Int
    public let totalResults: Int
    
    public init(page: Int, items: [TrendingItem], totalPages: Int, totalResults: Int) {
        self.page = page
        self.items = items
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
