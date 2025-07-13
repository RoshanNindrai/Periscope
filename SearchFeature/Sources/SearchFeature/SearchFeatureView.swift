import DataModel
import Lego
import PeriscopeUI
import Routes
import SwiftUI

public struct SearchFeatureView: View {

    @State
    private var viewModel: SearchFeatureViewModel

    @State
    private var searchText: String = ""

    @FocusState
    private var isSearchFocused: Bool

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.appRouter)
    private var appRouter: AppRouter?
    
    @Namespace
    private var namespace: Namespace.ID
    
    public init(
        viewModel: SearchFeatureViewModel
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            contentView
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )
                .padding()
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer,
            prompt: Text("Shows, Movies, and More")
        )
        .searchFocused($isSearchFocused)
        .onChange(of: searchText) { _, newValue in
            Task {
                await viewModel.reduce(action: .search(query: newValue))
            }
        }
        .onChange(of: isSearchFocused) { _, newValue in
            guard !newValue && searchText.isEmpty else { return }
            Task {
                await viewModel.reduce(action: .resetState)
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.output {
        case .initialized:
            infoText(
                "Search for Movies, TV Shows from TMDB Catalog."
            )
        case .emptySearchResults:
            infoText("No results to be found.")

        case .searchResult(let resultSet):
            LazyVStack(spacing: styleSheet.spacing.spacing200) {
                ForEach(resultSet, id: \.id) { mediaItem in
                    MediaRowButton(mediaItem)
                }
            }

        case .failedSearch:
            LegoProgressView()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center
                )
        }
    }

    @ViewBuilder
    private func infoText(_ text: String) -> some View {
        LegoText(text, style: styleSheet.text(.title))
            .multilineTextAlignment(.center)
    }

    @ViewBuilder
    private func MediaRowButton(_ media: any Media) -> some View {
        let selectedMediaInfo = MediaSelection(
            media: media,
            key: "Search-\(media.title)-\(media.id)"
        )
        
        Button {
            appRouter?.navigate(to: .detail(selectedMediaInfo), in: namespace)
        } label: {
            MediaRow(media: media)
        }
        .matchedTransitionSource(
            id: selectedMediaInfo,
            in: namespace
        )
    }
}
