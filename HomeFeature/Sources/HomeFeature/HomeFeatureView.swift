import DataModel
import Routes
import Lego
import SwiftUI
import PeriscopeUI

public struct HomeFeatureView: View {
    
    @State
    private var viewModel: HomeFeatureViewModel
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    @Binding
    private var selectedMediaInfo: MediaSelection?

    public init(
        viewModel: HomeFeatureViewModel,
        selectedMediaInfo: Binding<MediaSelection?>
    ) {
        self._viewModel = .init(initialValue: viewModel)
        self._selectedMediaInfo = selectedMediaInfo
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            content
                .padding(.bottom, styleSheet.spacing.spacing200)
        }
        .padding(
            .horizontal,
            styleSheet.spacing.spacing100
        )
        .refreshable {
            await viewModel.reduce(.fetchLatest)
        }
        .task {
            await viewModel.reduce(.fetchLatest)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.output {
        case .loading:
            LegoProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        case .fetched(let mediaCategories) where !mediaCategories.isEmpty:
            LazyVStack(spacing: styleSheet.spacing.spacing200, pinnedViews: []) {
                ForEach(mediaCategories) { mediaCategory in
                    sectionView(for: mediaCategory)
                }
            }
            .animation(.default, value: mediaCategories)
        case .fetched:
            VStack {
                LegoText("No content to show currently, please try again later.", style: styleSheet.text(.caption))
                    .multilineTextAlignment(.center)
                    .padding()
            }.frame(maxWidth: .infinity)
        case .failed(let error):
            LegoText(
                error.localizedDescription,
                style: styleSheet.text(.caption)
            )
            .multilineTextAlignment(.center)
            .padding()
        }
    }

    @ViewBuilder
    private func sectionView(for mediaCategory: MediaCategory) -> some View {
        switch mediaCategory {
        case .trendingToday:
            HeroBannerView(
                items: mediaCategory.mediaItems,
                selectedMediaInfo: $selectedMediaInfo
            )
            .frame(height: 507)
            .ignoresSafeArea(edges: .top)

        case .popularMovies, .popularTVShows, .topRated, .upcoming, .nowPlaying:
            HorizontalSectionView(
                mediaCategory: mediaCategory,
                selectedMediaInfo: $selectedMediaInfo
            )
        }
    }
}
