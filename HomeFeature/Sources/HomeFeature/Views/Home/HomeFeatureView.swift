import Lego
import SwiftUI
import TMDBRepository

public struct HomeFeatureView: View {
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    private let namespace: Namespace.ID
    
    @Binding
    private var selectedMediaInfo: Media?
    
    private let viewModel: HomeFeatureViewModel
    
    public init(viewModel: HomeFeatureViewModel, selectedMediaInfo: Binding<Media?>, namespace: Namespace.ID) {
        self.viewModel = viewModel
        self._selectedMediaInfo = selectedMediaInfo
        self.namespace = namespace
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
                                items: mediaList.items,
                                namespace: namespace
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
                                movieCategory: movieCategory,
                                namespace: namespace
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

