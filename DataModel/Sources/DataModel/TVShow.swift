import Foundation

public struct TVShow: Media, Searchable, Equatable, Sendable {
    public let adult: Bool
    public let backdropPath: String?
    public let genreIds: [Int]
    public let id: Int
    public let originCountry: [String]
    public let originalLanguage: String
    public let originalName: String
    public let overview: String
    public let popularity: Double
    public let posterPath: String?
    public let firstAirDate: String
    public let name: String
    public let voteAverage: Double
    public let voteCount: Int
    
    public init(
        adult: Bool,
        backdropPath: String?,
        genreIds: [Int],
        id: Int,
        originCountry: [String],
        originalLanguage: String,
        originalName: String,
        overview: String,
        popularity: Double,
        posterPath: String?,
        firstAirDate: String,
        name: String,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.id = id
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.firstAirDate = firstAirDate
        self.name = name
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    public var title: String {
        name
    }
    
    public var releaseDate: String {
        firstAirDate
    }
    
    public var type: MediaItemType {
        .tvShow
    }
    
    public var seachItemType: SearchItemType {
        .tvShow
    }
    
    public var subtitle: String {
        releaseDate
    }
}
