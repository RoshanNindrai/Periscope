import Lego
import SwiftUI
import TMDBRepository

struct MovieCategoryView: View {
    
    private let movieCategory: MovieCategory
    private let onSelection: (Movie) -> Void
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    init(
        movieCategory: MovieCategory,
        onSelection: @escaping (Movie) -> Void = { _ in }
    ) {
        self.movieCategory = movieCategory
        self.onSelection = onSelection
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing50) {
            
            HStack(spacing: styleSheet.spacing.spacing50) {
                LegoText(
                    movieCategory.title, style: styleSheet.text(.title)
                )
                
                Image(
                    systemName: "chevron.right"
                ).font(
                    styleSheet.typography.subtitle
                )
            }
            .padding(.leading, styleSheet.spacing.spacing100)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: styleSheet.spacing.spacing100) {
                    ForEach(
                        Array(movieCategory.movieList.movies.enumerated()),
                        id: \.element.id
                    ) { rowIndex, movie in
                        MovieTileView(
                            movie: movie
                        )
                        .onTapGesture {
                            onSelection(movie)
                        }
                        .padding(
                            .leading, rowIndex == .zero ? styleSheet.spacing.spacing100 : .zero
                        )
                    }
                }
            }
            .frame(height: 250)
        }
    }
}

#Preview {
    MovieCategoryView(
        movieCategory: .popular(
            .init(
                movies: [
                    Movie(
                        adult: false,
                        backdropPath: "/uIpJPDNFoeX0TVml9smPrs9KUVx.jpg",
                        genreIds: [27, 9648],
                        id: 574475,
                        originalLanguage: "en",
                        originalTitle: "Final Destination Bloodlines",
                        overview: "Plagued by a violent recurring nightmare, college student Stefanie heads home to track down the one person who might be able to break the cycle and save her family from the grisly demise that inevitably awaits them all.",
                        popularity: 780.9277,
                        posterPath: "/6WxhEvFsauuACfv8HyoVX6mZKFj.jpg",
                        releaseDate: "2025-05-14",
                        title: "Final Destination Bloodlines",
                        video: false,
                        voteAverage: 7.206,
                        voteCount: 1286
                    ),
                    Movie(
                        adult: false,
                        backdropPath: "/xtnfoFs9vOLBF7Ox13mFmFUovey.jpg",
                        genreIds: [28, 12, 18],
                        id: 1311844,
                        originalLanguage: "en",
                        originalTitle: "The Twisters",
                        overview: "A deadly patchwork of destructive cyclones is on an apocalyptic path of convergence at a populated Midwest city center. There, the twisters will merge into one mega tornado that threatens to obliterate the cities for hundreds of miles around.",
                        popularity: 458.2578,
                        posterPath: "/8OP3h80BzIDgmMNANVaYlQ6H4Oc.jpg",
                        releaseDate: "2024-06-28",
                        title: "The Twisters",
                        video: false,
                        voteAverage: 5.833,
                        voteCount: 24
                    ),
                    Movie(
                        adult: false,
                        backdropPath: "/7Zx3wDG5bBtcfk8lcnCWDOLM4Y4.jpg",
                        genreIds: [10751, 878, 35, 12],
                        id: 552524,
                        originalLanguage: "en",
                        originalTitle: "Lilo & Stitch",
                        overview: "The wildly funny and touching story of a lonely Hawaiian girl and the fugitive alien who helps to mend her broken family.",
                        popularity: 407.4868,
                        posterPath: "/7c5VBuCbjZOk7lSfj9sMpmDIaKX.jpg",
                        releaseDate: "2025-05-17",
                        title: "Lilo & Stitch",
                        video: false,
                        voteAverage: 7.1,
                        voteCount: 718
                    ),
                    Movie(
                        adult: false,
                        backdropPath: "/zxjFabSJKMAvuu3acNg78nuTuCs.jpg",
                        genreIds: [28, 53, 27],
                        id: 1442776,
                        originalLanguage: "zh",
                        originalTitle: "Kuang Bao Ju Xi",
                        overview: "A young man climbs into the mountains to pick up a meteorite that has fallen there and is killed by something. The \"thing\" descends to the village and begins to eat the inhabitants one by one, terrorizing the entire island.",
                        popularity: 364.7731,
                        posterPath: "/9TFaFsSXedaALXTzba349euDeoY.jpg",
                        releaseDate: "2024-03-27",
                        title: "Crazy Lizard",
                        video: false,
                        voteAverage: 6.056,
                        voteCount: 18
                    ),
                    Movie(
                        adult: false,
                        backdropPath: "/v47JpEeMlO0zNWCngouh0MafchU.jpg",
                        genreIds: [878, 35, 28],
                        id: 605722,
                        originalLanguage: "en",
                        originalTitle: "Distant",
                        overview: "After crash-landing on an alien planet, an asteroid miner must contend with the challenges of his new surroundings, while making his way across the harsh terrain to the only other survivor – a woman who is trapped in her escape pod.",
                        popularity: 395.7042,
                        posterPath: "/czh8HOhsbBUKoKsmRmLQMCLHUev.jpg",
                        releaseDate: "2024-07-12",
                        title: "Distant",
                        video: false,
                        voteAverage: 6.283,
                        voteCount: 136
                    ),
                    Movie(
                        adult: false,
                        backdropPath: "/7HqLLVjdjhXS0Qoz1SgZofhkIpE.jpg",
                        genreIds: [14, 10751, 28],
                        id: 1087192,
                        originalLanguage: "en",
                        originalTitle: "How to Train Your Dragon",
                        overview: "On the rugged isle of Berk, where Vikings and dragons have been bitter enemies for generations, Hiccup stands apart, defying centuries of tradition when he befriends Toothless, a feared Night Fury dragon. Their unlikely bond reveals the true nature of dragons, challenging the very foundations of Viking society.",
                        popularity: 344.9682,
                        posterPath: "/q5pXRYTycaeW6dEgsCrd4mYPmxM.jpg",
                        releaseDate: "2025-06-06",
                        title: "How to Train Your Dragon",
                        video: false,
                        voteAverage: 7.908,
                        voteCount: 418
                    ),
                    Movie(
                        adult: false,
                        backdropPath: "/9f06S7Uc1Xmnc3OYtK8UKu9o3Ox.jpg",
                        genreIds: [28, 12, 27],
                        id: 1181039,
                        originalLanguage: "zh",
                        originalTitle: "鬼吹灯：献王虫谷",
                        overview: "Adapted from the 3rd volume in the novel series \"Candle in the Tomb\" by Zhang Mu Ye...",
                        popularity: 307.5748,
                        posterPath: "/7Hk1qxAvZi9H9cfBb4iHkoGjapH.jpg",
                        releaseDate: "2023-09-22",
                        title: "Candle in the Tomb: The Worm Valley",
                        video: false,
                        voteAverage: 6.471,
                        voteCount: 17
                    )
                ],
                page: 1,
                totalPages: 15,
                totalResults: 134
            )
        )
    )
}
