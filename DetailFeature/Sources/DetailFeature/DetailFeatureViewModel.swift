import Foundation
import TMDBRepository
import DataModel

@MainActor
@Observable
public final class DetailFeatureViewModel {
    
    internal enum State {
        case idle
        case loading
        case loadedRelatedMovies(MediaList)
        case failed(Error)
    }
    
    internal enum Action {
        case loadOtherInformation(any Media)
    }
    
    private let repository: TMDBRepository
    private(set) var state: State = .idle
    
    public init(repository: TMDBRepository) {
        self.repository = repository
    }
    
    func reduce(_ action: Action) async {
        switch action {
        case .loadOtherInformation(let media):
            state = .loading
            do {
                let related = try await repository.relatedMedia(
                    for: media.mediaItemRequest
                )
                state = .loadedRelatedMovies(related)
            } catch {
                state = .failed(error)
            }
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
