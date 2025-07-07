import Combine
import DataModel
import SwiftUI
import TMDBRepository

@MainActor
@Observable
public final class SearchFeatureViewModel {
    
    private let repository: TMDBRepository
    private var cancellable: AnyCancellable?
    
    public init(repository: TMDBRepository) {
        self.repository = repository
    }
    
    enum Output {
        case initialized
        case searchResult([any Media])
        case emptySearcResults
        case failedSearch(Error)
    }
    
    enum Action {
        case resetState
        case search(query: String)
    }
    
    private(set) var output: Output = .initialized
    
    @ObservationIgnored
    private var searchTask: Task<Void, Never>?
    
    func reduce(action: Action) async {
        switch action {
        case .search(let query):
            guard !query.isEmpty else {
                return
            }
            
            searchTask?.cancel()
            searchTask = Task.detached(priority: .userInitiated) { [repository] in
                
                guard !Task.isCancelled else {
                    return
                }
                
                let result: Output
                
                do {
                    try await Task.sleep(for: .milliseconds(500))
                    let searchResultSet = try await repository.search(for: query)
                    let mediaItems = searchResultSet.items.compactMap(\.media)
                    result = mediaItems.isEmpty ? .emptySearcResults : .searchResult(mediaItems)
                }
                catch {
                    result = .failedSearch(error)
                }

                await MainActor.run {
                    withAnimation(.easeIn) {
                        self.output = result
                    }
                }
            }
            
        case .resetState:
            withAnimation(.easeIn) {
                self.output = .initialized
            }
        }
    }
}
