import Routes
import Lego
import SwiftUI
import TMDBRepository

struct HeroBannerView: View {
    
    private let items: [Media]
    private let onSelect: ((Media) -> Void)?
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.namespace)
    private var namespace: Namespace.ID!
    
    @State
    private var selectedItemIndex: Int = 0
    
    init(items: [Media], onSelect: ((Media) -> Void)? = nil) {
        self.items = items
        self.onSelect = onSelect
    }
    
    var body: some View {
        TabView(selection: $selectedItemIndex) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, media in
                Button {
                    onSelect?(media)
                } label: {
                    MediaTileView(
                        movie: media,
                        assetQuality: .medium
                    )
                    .tag(index)
                    .scaledToFit()
                    .matchedTransitionSource(
                        id: media.id,
                        in: namespace
                    )
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    HeroBannerView(
        items: [Media(
            adult: false,
            backdropPath: "",
            genreIds: [],
            id: 1,
            originalLanguage: "en",
            originalTitle: "Title",
            overview: "Overview...",
            popularity: 1,
            posterPath: "",
            releaseDate: "2025-01-01",
            title: "Title",
            video: false,
            voteAverage: 8.0,
            voteCount: 100)],
        onSelect: nil
    )
}
