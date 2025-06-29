import Routes
import Lego
import SwiftUI
import TMDBRepository

struct HeroBannerView: View {
    
    enum Size {
        static let height: CGFloat = 507
        static let width: CGFloat = height * (2/3)
    }
    
    private let items: [any Media]
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.namespace)
    private var namespace: Namespace.ID!
    
    @State
    private var selectedItemIndex: Int = 0
    
    @Binding
    private var selectedMediaInfo: MediaSelection?
    
    init(items: [any Media], selectedMediaInfo: Binding<MediaSelection?>) {
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
                        posterSize: .w780
                    )
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: Size.width, height: Size.height)
                }
                .matchedTransitionSource(
                    id: MediaSelection(
                        media: media,
                        key: "Hero-\(media.id)"
                    ),
                    in: namespace
                )
                .tag(index)
            }
            .frame(width: Size.width, height: Size.height)
        }

        .scrollIndicators(.never)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    
    let items = [
        Movie(
            adult: false,
            backdropPath: "",
            genreIds: [],
            id: 1,
            originalLanguage: "en",
            originalTitle: "Title",
            overview: "Overview...",
            popularity: 1,
            posterPath: "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg",
            releaseDate: "2025-01-01",
            title: "Title",
            video: false,
            voteAverage: 8.0,
            voteCount: 100
        ),
        Movie(
            adult: false,
            backdropPath: "/xDMIl84Qo5Tsu62c9DGWhmPI67A.jpg",
            genreIds: [28, 12, 878],
            id: 505642,
            originalLanguage: "en",
            originalTitle: "Black Panther: Wakanda Forever",
            overview: "Queen Ramonda, Shuri, M’Baku and the Dora Milaje fight to protect Wakanda from intervening world powers in the wake of King T’Challa’s death.",
            popularity: 1234.56,
            posterPath: "/sv1xJUazXeYqALzczSZ3O6nkH75",
            releaseDate: "2022-11-11",
            title: "Black Panther: Wakanda Forever",
            video: false,
            voteAverage: 7.3,
            voteCount: 1892
        ),
    ]
    
    HeroBannerView(
        items: items,
        selectedMediaInfo: .constant(MediaSelection(media: items.first!, key: ""))
    )
}

