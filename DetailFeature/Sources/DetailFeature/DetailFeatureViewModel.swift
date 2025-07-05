import Foundation
import TMDBRepository
import DataModel

@MainActor
@Observable
public final class DetailFeatureViewModel {
    
    internal enum Output {
        case idle
        case loading
        case fetched([MediaDetailCategory])
        case failed(Error)
    }
    
    internal enum Action {
        case loadOtherInformation(any Media)
    }
    
    private let repository: TMDBRepository
    private(set) var output: Output = .idle
    
    public init(repository: TMDBRepository) {
        self.repository = repository
    }
    
    func reduce(_ action: Action) async {
        switch action {
        case .loadOtherInformation(let media):
            async let mediaDetail: MediaDetailCategory? = try? .mediaDetail(repository.mediaDetail(for: media.mediaItemRequest))
            async let relatedMedia: MediaDetailCategory? = try? .relatedMedia(repository.relatedMedia(for: media.mediaItemRequest))
            async let castAndCrew: MediaDetailCategory? = try? .castAndCrew(repository.castAndCrewList(for: media.mediaItemRequest))
            
            let result: [MediaDetailCategory] = await [
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
