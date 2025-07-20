import Foundation

public struct WatchProviders: Equatable, Sendable {
    public let id: Int
    public let regions: [WatchProviderRegion]

    public init(
        id: Int,
        regions: [WatchProviderRegion]
    ) {
        self.id = id
        self.regions = regions
    }
    
    public func watchProvider(
        for countryCode: String
    ) -> WatchProviderRegion? {
        regions.first { $0.countryCode == countryCode }
    }
}

public struct WatchProviderRegion: Equatable, Sendable {
    public let countryCode: String
    public let link: String
    public let providers: [WatchProvider]

    public init(
        countryCode: String,
        link: String,
        providers: [WatchProvider]
    ) {
        self.countryCode = countryCode
        self.link = link
        self.providers = providers.sorted { $0.displayPriority < $1.displayPriority }
    }
}

public struct WatchProvider: Equatable, Sendable, Identifiable {
    public let id: Int
    public let name: String
    public let logoPath: String
    public let displayPriority: Int

    public init(
        id: Int,
        name: String,
        logoPath: String,
        displayPriority: Int
    ) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.displayPriority = displayPriority
    }
}

