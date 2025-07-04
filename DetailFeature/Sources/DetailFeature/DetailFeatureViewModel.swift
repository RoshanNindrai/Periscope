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
        case loadOtherInformation(mediaId: Int)
    }
    
    private let repository: TMDBRepository
    private(set) var state: State = .idle
    
    public init(repository: TMDBRepository) {
        self.repository = repository
    }
    
    func reduce(_ action: Action) async {
        switch action {
        case .loadOtherInformation(let mediaId):
            state = .loading
            do {
                let related = try await repository.relatedMovies(for: mediaId)
                state = .loadedRelatedMovies(related)
            } catch {
                state = .failed(error)
            }
        }
    }
}
