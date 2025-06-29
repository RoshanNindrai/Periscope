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
    private var selectedMediaInfo: MediaSelection<Media>?
    
    public init(
        viewModel: HomeFeatureViewModel,
        selectedMediaInfo: Binding<MediaSelection<Media>?>
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
                        case .nowPlaying(let mediaList):
                            HeroBannerView(
                                items: mediaList.items,
                                selectedMediaInfo: $selectedMediaInfo
                            )
                            .frame(
                                maxWidth: .infinity
                            ).frame(
                                height: UIScreen.main.bounds.height * 0.5
                            )
                            .ignoresSafeArea()
                        case .popular, .topRated, .upcoming:
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

