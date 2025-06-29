import Routes
import Lego
import SwiftUI
import TMDBRepository

public struct HomeFeatureView: View {
    
    private let viewModel: HomeFeatureViewModel
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.namespace)
    private var namespace: Namespace.ID!
    
    @Binding
    private var selectedMediaInfo: MediaSelection?
    
    public init(
        viewModel: HomeFeatureViewModel,
        selectedMediaInfo: Binding<MediaSelection?>
    ) {
        self.viewModel = viewModel
        self._selectedMediaInfo = selectedMediaInfo
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            switch viewModel.output {
            case .loading:
                LegoProgressView()
            case .fetched(let mediaCategories):
                LazyVStack {
                    ForEach(mediaCategories) { mediaCategory in
                        switch mediaCategory {
                        case .trendingToday:
                            HeroBannerView(
                                items: mediaCategory.mediaItems,
                                selectedMediaInfo: $selectedMediaInfo
                            ).frame(
                                height: UIScreen.main.bounds.height * 0.66
                            )
                            .ignoresSafeArea()
                        case .popularMovies, .popularTVShows, .topRated, .upcoming, .nowPlaying:
                            HorizontalSectionView(
                                mediaCategory: mediaCategory,
                                selectedMediaInfo: $selectedMediaInfo
                            )
                        }
                    }
                }
            case .failed(let error):
                LegoText(
                    error.localizedDescription,
                    style: styleSheet.text(.caption)
                )
            }
        }
        .refreshable {
            await viewModel.reduce(.fetchLatest)
        }
        .task {
            await viewModel.reduce(.fetchLatest)
        }
    }
}

