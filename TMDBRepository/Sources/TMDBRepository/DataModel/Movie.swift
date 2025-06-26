import Foundation

public struct Movie: Sendable {
    public let adult: Bool
    public let backdropPath: String?
    public let genreIds: [Int]
    public let id: Int
    public let originalLanguage: String
    public let originalTitle: String
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
        originalTitle: String,
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
}

// MARK: Helpers

public extension Movie {
    
    private static let baseImageURLString = "https://image.tmdb.org/t/p/"
    
    // THIS IS UGLY!!!!
    
    func posterURL(size: String = "w200") -> URL {
        guard let posterPath = posterPath else {
            return URL(string: "")!
        }
        return URL(string: "\(Movie.baseImageURLString)\(size)\(posterPath)")!
    }
    
    func backDropURL(size: String = "w500") -> URL {
        guard let posterPath = backdropPath else {
            return URL(string: "")!
        }
        return URL(string: "\(Movie.baseImageURLString)\(size)\(posterPath)")!
    }
}
