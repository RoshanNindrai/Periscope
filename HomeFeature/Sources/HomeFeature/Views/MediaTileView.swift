import Lego
import SwiftUI
import TMDBRepository

struct MediaTileView: View {
    private let media: Media
    private let assetQuality: Media.AssetQuality
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    init(media: Media, assetQuality: Media.AssetQuality = .small) {
        self.media = media
        self.assetQuality = assetQuality
    }
    
    var body: some View {
        VStack {
            LegoAsyncImage(
                url: media.posterURL(quality: assetQuality),
                placeholder: {
                    LegoText(
                        media.title,
                        style: styleSheet.text(.caption)
                    ) { text in
                        text.multilineTextAlignment(.center)
                    }
                }) { image in
                    image.resizable()
                        .scaledToFit()
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(styleSheet.colors.background)
        }.cornerRadius(
            styleSheet.spacing.spacing100
        )
    }
}

#Preview {
    MediaTileView(
        media: .init(
            adult: false,
            backdropPath: "/xDMIl84Qo5Tsu62c9DGWhmPI67A.jpg",
            genreIds: [28, 12, 878],
            id: 505642,
            originalLanguage: "en",
            originalTitle: "Black Panther: Wakanda Forever",
            overview: "Queen Ramonda, Shuri, M’Baku and the Dora Milaje fight to protect Wakanda from intervening world powers in the wake of King T’Challa’s death.",
            popularity: 1234.56,
            posterPath: "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg",
            releaseDate: "2022-11-11",
            title: "Black Panther: Wakanda Forever",
            video: false,
            voteAverage: 7.3,
            voteCount: 1892
        )
    ).border(.red)
}
