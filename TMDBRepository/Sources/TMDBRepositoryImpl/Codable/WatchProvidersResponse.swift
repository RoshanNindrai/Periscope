import Foundation
import DataModel

struct WatchProvidersResponse: Decodable {
    let id: Int
    let results: [String: WatchProviderRegionResponse]

    init(id: Int, results: [String: WatchProviderRegionResponse]) {
        self.id = id
        self.results = results
    }
}

struct WatchProviderRegionResponse: Decodable {
    let link: String
    let flatrate: [WatchProviderResponse]?

    init(link: String, flatrate: [WatchProviderResponse]?) {
        self.link = link
        self.flatrate = flatrate
    }
}

struct WatchProviderResponse: Decodable {
    let logoPath: String
    let providerID: Int
    let providerName: String
    let displayPriority: Int

    init(
        logoPath: String,
        providerID: Int,
        providerName: String,
        displayPriority: Int
    ) {
        self.logoPath = logoPath
        self.providerID = providerID
        self.providerName = providerName
        self.displayPriority = displayPriority
    }

    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
        case providerID = "provider_id"
        case providerName = "provider_name"
        case displayPriority = "display_priority"
    }
}

extension WatchProvidersResponse {
    func toDomainModel() -> WatchProviders {
        let regions = results.map { countryCode, regionResponse in
            WatchProviderRegion(
                countryCode: countryCode,
                link: regionResponse.link,
                providers: regionResponse.flatrate?.map { $0.toDomainModel() } ?? []
            )
        }

        return WatchProviders(
            id: id,
            regions: regions
        )
    }
}

extension WatchProviderRegionResponse {
    func toDomainModel(countryCode: String) -> WatchProviderRegion {
        WatchProviderRegion(
            countryCode: countryCode,
            link: link,
            providers: flatrate?.map { $0.toDomainModel() } ?? []
        )
    }
}

extension WatchProviderResponse {
    func toDomainModel() -> WatchProvider {
        WatchProvider(
            id: providerID,
            name: providerName,
            logoPath: logoPath,
            displayPriority: displayPriority
        )
    }
}

