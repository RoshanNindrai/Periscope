import Foundation

public struct TrendingMediaList: PageableMediaList, Equatable, Sendable {
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
    
    public static func == (lhs: TrendingMediaList, rhs: TrendingMediaList) -> Bool {
        lhs.page == rhs.page &&
        lhs.totalPages == rhs.totalPages &&
        lhs.totalResults == rhs.totalResults &&
        lhs.items.count == rhs.items.count &&
        zip(lhs.items, rhs.items).allSatisfy { l, r in
            l.id == r.id
        }
    }
}
