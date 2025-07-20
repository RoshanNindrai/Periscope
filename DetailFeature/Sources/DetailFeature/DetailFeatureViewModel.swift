import Foundation
import TMDBRepository
import DataModel
import Utils

@MainActor
@Observable
public final class DetailFeatureViewModel {
    
    enum Output {
        case idle
        case loading
        case fetched([MediaDetailCategory])
        case failed(Error)
    }
    
    enum Action {
        case loadOtherInformation(any Media)
    }
    
    @ObservationIgnored
    let repository: TMDBRepository
    
    @ObservationIgnored
    let countryCodeProvider: CountryCodeProviding

    private(set) var output: Output = .idle
    
    public init(repository: TMDBRepository, countryCodeProvider: CountryCodeProviding) {
        self.repository = repository
        self.countryCodeProvider = countryCodeProvider
    }
    
    func reduce(_ action: Action) async {
        switch action {
        case .loadOtherInformation(let media):
            
            async let mediaDetail: MediaDetailCategory? = try? .mediaDetail(repository.mediaDetail(for: media.mediaItemRequest))
            async let relatedMedia: MediaDetailCategory? = try? .relatedMedia(repository.relatedMedia(for: media.mediaItemRequest))
            async let castAndCrew: MediaDetailCategory? = try? .castAndCrew(repository.castAndCrewList(for: media.mediaItemRequest))
            async let watchProvider: MediaDetailCategory? = try? .watchProvider(repository.watchProvider(for: media, in: await countryCodeProvider.countryCode()))
            
            let result: [MediaDetailCategory] = await [
                watchProvider,
                castAndCrew,
                relatedMedia,
                mediaDetail
            ].compactMap { $0 }

            output = .fetched(result)
        }
    }
}

private extension Media {
    var mediaItemRequest: MediaItem {
        switch type {
        case .movie:
            .movie(id: id)
        case .tvShow:
            .tvShow(id: id)
        }
    }
}

public extension TMDBRepository {
    func watchProvider(for media: any Media, in countryCode: String?) async throws -> WatchProviderRegion? {
        guard let countryCode = countryCode else { return nil }

        let watchProviders = try await watchProviders(for: media.mediaItemRequest)        
        return watchProviders.watchProvider(for: countryCode)
    }
}
