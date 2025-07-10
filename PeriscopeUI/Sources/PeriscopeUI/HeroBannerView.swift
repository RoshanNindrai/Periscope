// HeroBannerView displays a horizontally paged set of media items in a prominent banner style, allowing users to select featured content.
import DataModel
import Routes
import Lego
import SwiftUI

public struct HeroBannerView: View {
    // Size constants for the banner display
    enum Size {
        static let height: CGFloat = 507
        static let width: CGFloat = height * (2 / 3)
    }

    // The media items to display in the banner
    private let items: [any Media]

    // Access the app's style sheet from the environment
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    // Currently selected banner index
    @State
    private var selectedItemIndex: Int = 0

    private let onSelect: (MediaSelection) -> Void
    private let transitionSourceBuilder: (MediaSelection, AnyView) -> AnyView

    // Initialize with items to display and binding to selection
    public init(
            items: [any Media],
            onSelect: @escaping (MediaSelection) -> Void,
            transitionSourceBuilder: @escaping (MediaSelection, AnyView) -> AnyView
    ) {
        self.items = items
        self.onSelect = onSelect
        self.transitionSourceBuilder = transitionSourceBuilder
    }

    public var body: some View {
        // TabView provides horizontal paging for banners
        TabView(selection: $selectedItemIndex) {
            ForEach(items.indices, id: \.self) { index in
                mediaTileButton(for: items[index], index: index)
            }
        }
        .frame(height: Size.height)
        .scrollIndicators(.never)
        .tabViewStyle(.page(indexDisplayMode: .always)) // Shows page indicator dots
        .ignoresSafeArea(edges: .top)
    }

    /// Creates a tappable media tile for the banner, triggering selection and matched transitions
    @ViewBuilder
    private func mediaTileButton(for media: any Media, index: Int) -> some View {
        let selection = MediaSelection(media: media, key: "Hero-\(media.id)")

        let base = AnyView(
            Button {
                onSelect(selection)
            } label: {
                MediaTileView(media: media, posterSize: .w780)
                    .buttonStyle(.plain)
            }
            .frame(width: Size.width, height: Size.height)
            .tag(index)
        )

        transitionSourceBuilder(selection, base)
    }
}

// Preview for HeroBannerView with sample movies for design/testing
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
        onSelect: { _ in },
        transitionSourceBuilder: { selection, base in base }
    )
}
