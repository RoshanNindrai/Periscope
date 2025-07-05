import Foundation

public struct MovieDetail: MediaDetail {
    public let adult: Bool
    public let backdropPath: String?
    public let belongsToCollection: CollectionInfo?
    public let budget: Int
    public let genres: [Genre]
    public let homepage: String?
    public let id: Int
    public let imdbID: String?
    public let originCountry: [String]
    public let originalLanguage: String
    public let originalTitle: String
    public let overview: String
    public let popularity: Double
    public let posterPath: String?
    public let productionCompanies: [ProductionCompany]
    public let productionCountries: [ProductionCountry]
    public let releaseDate: String
    public let revenue: Int
    public let runtime: Int?
    public let spokenLanguages: [SpokenLanguage]
    public let status: String
    public let tagline: String
    public let title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int

    public init(
        adult: Bool,
        backdropPath: String?,
        belongsToCollection: CollectionInfo?,
        budget: Int,
        genres: [Genre],
        homepage: String?,
        id: Int,
        imdbID: String?,
        originCountry: [String],
        originalLanguage: String,
        originalTitle: String,
        overview: String,
        popularity: Double,
        posterPath: String?,
        productionCompanies: [ProductionCompany],
        productionCountries: [ProductionCountry],
        releaseDate: String,
        revenue: Int,
        runtime: Int?,
        spokenLanguages: [SpokenLanguage],
        status: String,
        tagline: String,
        title: String,
        video: Bool,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.belongsToCollection = belongsToCollection
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.imdbID = imdbID
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.runtime = runtime
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

public struct CollectionInfo: Equatable, Sendable {
    public let id: Int
    public let name: String
    public let posterPath: String?
    public let backdropPath: String?

    public init(id: Int, name: String, posterPath: String?, backdropPath: String?) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
}

public struct Genre: Equatable, Sendable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct ProductionCompany: Equatable, Sendable {
    public let id: Int
    public let logoPath: String?
    public let name: String
    public let originCountry: String
    
    public init(id: Int, logoPath: String?, name: String, originCountry: String) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
}

public struct ProductionCountry: Equatable, Sendable {
    public let iso3166_1: String
    public let name: String
    
    public init(iso3166_1: String, name: String) {
        self.iso3166_1 = iso3166_1
        self.name = name
    }
}

public struct SpokenLanguage: Equatable, Sendable {
    public let englishName: String
    public let iso639_1: String
    public let name: String
    
    public init(englishName: String, iso639_1: String, name: String) {
        self.englishName = englishName
        self.iso639_1 = iso639_1
        self.name = name
    }
}

extension MovieDetail {
    public var releaseDateText: String { releaseDate }
    public var runtimeInMinutes: Int? { runtime }
}
