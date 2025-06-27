import Lego
import SwiftUI

public struct HomeFeatureView: View {
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    private let viewModel: HomeFeatureViewModel
    
    public init(viewModel: HomeFeatureViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            switch viewModel.output {
            case .loading:
                LegoProgressView()
            case .fetched(let movieCategories):
                LazyVStack {
                    ForEach(movieCategories) {
                        MovieCategoryView(
                            movieCategory: $0
                        )
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
