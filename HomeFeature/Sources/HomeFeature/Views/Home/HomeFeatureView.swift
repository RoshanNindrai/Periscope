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
    private var selectedMediaInfo: Media?
    
    public init(viewModel: HomeFeatureViewModel, selectedMediaInfo: Binding<Media?>) {
        self.viewModel = viewModel
        self._selectedMediaInfo = selectedMediaInfo
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            switch viewModel.output {
            case .loading:
                LegoProgressView()
            case .fetched(let movieCategories):
                LazyVStack {
                    ForEach(movieCategories) { movieCategory in
                        switch movieCategory {
                        case .nowPlaying(let mediaList):
                            HeroBannerView(
                                items: mediaList.items
                            ) {
                                selectedMediaInfo = $0
                            }
                            .frame(
                                maxWidth: .infinity
                            ).frame(
                                height: UIScreen.main.bounds.height * 0.5
                            )
                            .ignoresSafeArea()
                        case .popular, .topRated, .upcoming:
                            HorizontalSectionView(
                                movieCategory: movieCategory
                            ) {
                                selectedMediaInfo = $0
                            }
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

