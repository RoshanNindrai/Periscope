import Lego
import SwiftUI
import TMDBRepository

struct MediaTileView: View {
    private let media: any Media
    private let posterSize: PosterSize
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.tmdbImageURLBuilder)
    private var tmdbImageURLBuilder: TMDBImageURLBuilder
    
    init(media: any Media, posterSize: PosterSize = .w342) {
        self.media = media
        self.posterSize = posterSize
    }
    
    var body: some View {
        VStack {
            LegoAsyncImage(
                url: tmdbImageURLBuilder.posterImageURL(
                    media: media,
                    size: posterSize
                ),
                placeholder: {
                    LegoText(
                        media.title,
                        style: styleSheet.text(.caption)
                    ) { text in
                        text.multilineTextAlignment(.center)
                    }
                    .padding(styleSheet.spacing.spacing200)
                }) { image in
                    image
                        .resizable()
                        .scaledToFit()
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(styleSheet.colors.background)
        }
        .cornerRadius(
            styleSheet.spacing.spacing100
        )
    }
}

#Preview {
    MediaTileView(
        media: Movie(
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
        )
    ).border(.red)
}
