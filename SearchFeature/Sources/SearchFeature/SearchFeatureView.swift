import DataModel
import Lego
import PeriscopeUI
import Routes
import SwiftUI

public struct SearchFeatureView: View {
    
    private let viewModel: SearchFeatureViewModel
    
    @State
    private var searchText: String  = ""
    
    @Binding
    private var selectedMediaInfo: MediaSelection?
    
    @FocusState
    private var isSearchFocused: Bool
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.namespace)
    private var namespace: Namespace.ID!
    
    
    public init(viewModel: SearchFeatureViewModel, selectedMediaInfo: Binding<MediaSelection?>) {
        self.viewModel = viewModel
        self._selectedMediaInfo = selectedMediaInfo
    }
    
    public var body: some View {
        ScrollView {
            switch viewModel.output {
            case .initialized:
                LegoText("Search for Movies, TV Shows from TMDB Catalog.", style: styleSheet.text(.title))
                    .multilineTextAlignment(.center)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    ).padding()
            case .emptySearcResults:
                LegoText("No results to be found.", style: styleSheet.text(.title))
                    .multilineTextAlignment(.center)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    ).padding()
            case .searchResult(let resultSet):
                VStack {
                    ForEach(resultSet, id:\.id) { mediaItem in
                        Button {
                            selectedMediaInfo = MediaSelection(
                                media: mediaItem,
                                key: "Search-\(mediaItem.title)-\(mediaItem.id)"
                            )
                        } label: {
                            MediaRow(media: mediaItem)
                                .matchedTransitionSource(
                                    id: "Search-\(mediaItem.title)-\(mediaItem.id)",
                                    in: namespace
                                )
                        }
                    }
                }
            case .failedSearch:
                LegoProgressView()
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer,
            prompt: Text("Shows, Movies, and More")
        )
        .searchFocused($isSearchFocused)
        .onChange(of: searchText) { oldValue, newValue in
            Task {
                await viewModel.reduce(action: .search(query: newValue))
            }
        }
        .onChange(of: isSearchFocused) { oldValue, newValue in
            guard !newValue && searchText.isEmpty else {
                return
            }
            
            Task {
                await viewModel.reduce(action: .resetState)
            }
        }
    }
}
