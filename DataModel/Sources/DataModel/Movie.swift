import Foundation

public struct Movie: Media, Searchable, Hashable, Sendable {
    public let adult: Bool
    public let backdropPath: String?
    public let genreIds: [Int]
    public let id: Int
    public let originalLanguage: String
    public let originalTitle: String?
    public let overview: String
    public let popularity: Double
    public let posterPath: String?
    public let releaseDate: String
    public let title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int
    
    public init(
        adult: Bool,
        backdropPath: String?,
        genreIds: [Int],
        id: Int,
        originalLanguage: String,
        originalTitle: String?,
        overview: String,
        popularity: Double,
        posterPath: String?,
        releaseDate: String,
        title: String,
        video: Bool,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    public var type: MediaItemType {
        .movie
    }
    
    public var searchItemType: SearchItemType {
        .movie
    }
    
    public var subtitle: String {
        overview
    }
}

// MARK: Helpers

public extension Movie {
    static let example = Movie(
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
}
