import Lego
import SwiftUI
import TMDBRepository

struct MovieTileView: View {
    private let movie: Movie
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var body: some View {
        VStack {
            LegoAsyncImage(
                url: movie.posterURL(),
                placeholder: {
                    Rectangle()
                        .fill(styleSheet.colors.background)
                }) { image in
                    image.resizable()
                        .scaledToFit()
                }
        }.cornerRadius(styleSheet.spacing.spacing100)
        .frame(
            width: 140,
            height: 210
        )
    }
}

#Preview {
    MovieTileView(
        movie: .init(
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
