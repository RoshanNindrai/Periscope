import Routes
import Lego
import SwiftUI
import TMDBRepository

struct HeroBannerView: View {
    
    private let items: [Media]
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.namespace)
    private var namespace: Namespace.ID!
    
    @State
    private var selectedItemIndex: Int = 0
    
    @Binding
    private var selectedMediaInfo: MediaSelection<Media>?
    
    init(items: [Media], selectedMediaInfo: Binding<MediaSelection<Media>?>) {
        self.items = items
        self._selectedMediaInfo = selectedMediaInfo
    }
    
    var body: some View {
        TabView(selection: $selectedItemIndex) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, media in
                Button {
                    selectedMediaInfo = MediaSelection(
                        media: media,
                        key: "Hero-\(media.id)"
                    )
                } label: {
                    MediaTileView(
                        media: media,
                        assetQuality: .medium
                    )
                    .scaledToFit()
                    .matchedTransitionSource(
                        id: MediaSelection(
                            media: media,
                            key: "Hero-\(media.id)"
                        ),
                        in: namespace
                    )
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    
    let items = [
        Media(
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
            voteCount: 100
        )
    ]
    
    HeroBannerView(
        items: items,
        selectedMediaInfo: .constant(MediaSelection(media: items.first!, key: ""))
    )
}
