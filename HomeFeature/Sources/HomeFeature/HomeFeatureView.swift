import Lego
import SwiftUI

public struct HomeFeatureView: View {
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    private let viewModel: HomeFeatureViewModel
    
    public init(viewModel: HomeFeatureViewModel) {
        self.viewModel = viewModel
    }
    
    private var contentView: some View {
        ScrollView {}
            .background(.green)
        .task {
            await viewModel.reduce(.fetchLatest)
        }
    }
    
    public var body: some View {
        ScrollView {
            contentView
        }
    }
}
