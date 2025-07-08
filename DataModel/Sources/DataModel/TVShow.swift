import Foundation

/// Represents a TV show with various metadata, conforming to Media, Searchable, Equatable, and Sendable protocols.
public struct TVShow: Media, Searchable, Equatable, Sendable {
    /// Whether the TV show is for adults only.
    public let adult: Bool
    /// The path to the backdrop image.
    public let backdropPath: String?
    /// An array of genre identifiers associated with the TV show.
    public let genreIds: [Int]
    /// The unique identifier for the TV show.
    public let id: Int
    /// The list of origin countries for the TV show.
    public let originCountry: [String]
    /// The original language of the TV show.
    public let originalLanguage: String
    /// The original name of the TV show.
    public let originalName: String
    /// The overview or summary of the TV show.
    public let overview: String
    /// The popularity score of the TV show.
    public let popularity: Double
    /// The path to the poster image.
    public let posterPath: String?
    /// The first air date of the TV show.
    public let firstAirDate: String
    /// The name of the TV show.
    public let name: String
    /// The average vote score of the TV show.
    public let voteAverage: Double
    /// The total count of votes the TV show has received.
    public let voteCount: Int
    
    /// Initializes a new TVShow with all properties.
    /// - Parameters:
    ///   - adult: Whether the TV show is for adults only.
    ///   - backdropPath: The path to the backdrop image.
    ///   - genreIds: An array of genre identifiers.
    ///   - id: The unique identifier for the TV show.
    ///   - originCountry: The list of origin countries.
    ///   - originalLanguage: The original language of the TV show.
    ///   - originalName: The original name of the TV show.
    ///   - overview: The overview or summary.
    ///   - popularity: The popularity score.
    ///   - posterPath: The path to the poster image.
    ///   - firstAirDate: The first air date.
    ///   - name: The name of the TV show.
    ///   - voteAverage: The average vote score.
    ///   - voteCount: The total count of votes.
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
    
    /// The title of the TV show, derived from its name.
    public var title: String {
        name
    }
    
    /// The release date of the TV show, derived from its first air date.
    public var releaseDate: String {
        firstAirDate
    }
    
    /// The media item type, indicating this is a TV show.
    public var type: MediaItemType {
        .tvShow
    }
    
    /// The search item type, indicating this is a TV show.
    public var searchItemType: SearchItemType {
        .tvShow
    }
    
    /// A subtitle for the TV show, derived from the release date.
    public var subtitle: String {
        releaseDate
    }
}
