import Foundation

public struct ShowDetail: MediaDetail {
    public let id: Int
    public let name: String
    public let originalName: String
    public let overview: String
    public let tagline: String
    public let posterPath: String?
    public let backdropPath: String?
    public let homepage: String?
    public let status: String
    public let type: String
    public let originalLanguage: String
    public let popularity: Double
    public let voteAverage: Double
    public let voteCount: Int
    public let adult: Bool
    public let inProduction: Bool
    public let firstAirDate: String
    public let lastAirDate: String
    public let numberOfEpisodes: Int
    public let numberOfSeasons: Int

    public let genres: [Genre]
    public let languages: [String]
    public let originCountry: [String]
    public let spokenLanguages: [SpokenLanguage]
    public let networks: [ShowNetwork]
    public let productionCompanies: [ProductionCompany]
    public let productionCountries: [ProductionCountry]
    public let createdBy: [Creator]
    public let seasons: [Season]
    public let lastEpisodeToAir: Episode?
    public let nextEpisodeToAir: Episode?

    public init(
        id: Int,
        name: String,
        originalName: String,
        overview: String,
        tagline: String,
        posterPath: String?,
        backdropPath: String?,
        homepage: String?,
        status: String,
        type: String,
        originalLanguage: String,
        popularity: Double,
        voteAverage: Double,
        voteCount: Int,
        adult: Bool,
        inProduction: Bool,
        firstAirDate: String,
        lastAirDate: String,
        numberOfEpisodes: Int,
        numberOfSeasons: Int,
        genres: [Genre],
        languages: [String],
        originCountry: [String],
        spokenLanguages: [SpokenLanguage],
        networks: [ShowNetwork],
        productionCompanies: [ProductionCompany],
        productionCountries: [ProductionCountry],
        createdBy: [Creator],
        seasons: [Season],
        lastEpisodeToAir: Episode?,
        nextEpisodeToAir: Episode?
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.overview = overview
        self.tagline = tagline
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.homepage = homepage
        self.status = status
        self.type = type
        self.originalLanguage = originalLanguage
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.adult = adult
        self.inProduction = inProduction
        self.firstAirDate = firstAirDate
        self.lastAirDate = lastAirDate
        self.numberOfEpisodes = numberOfEpisodes
        self.numberOfSeasons = numberOfSeasons
        self.genres = genres
        self.languages = languages
        self.originCountry = originCountry
        self.spokenLanguages = spokenLanguages
        self.networks = networks
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.createdBy = createdBy
        self.seasons = seasons
        self.lastEpisodeToAir = lastEpisodeToAir
        self.nextEpisodeToAir = nextEpisodeToAir
    }
}


public struct ShowNetwork: Equatable, Sendable {
    public let id: Int
    public let name: String
    public let logoPath: String?
    public let originCountry: String
    public init(id: Int, name: String, logoPath: String?, originCountry: String) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.originCountry = originCountry
    }
}

public struct Creator: Equatable, Sendable {
    public let id: Int
    public let name: String
    public let gender: Int?
    public let profilePath: String?
    public init(id: Int, name: String, gender: Int?, profilePath: String?) {
        self.id = id
        self.name = name
        self.gender = gender
        self.profilePath = profilePath
    }
}

public struct Season: Equatable, Sendable {
    public let id: Int
    public let name: String
    public let overview: String
    public let airDate: String?
    public let episodeCount: Int
    public let posterPath: String?
    public let seasonNumber: Int
    public let voteAverage: Double
    public init(
        id: Int,
        name: String,
        overview: String,
        airDate: String?,
        episodeCount: Int,
        posterPath: String?,
        seasonNumber: Int,
        voteAverage: Double
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.airDate = airDate
        self.episodeCount = episodeCount
        self.posterPath = posterPath
        self.seasonNumber = seasonNumber
        self.voteAverage = voteAverage
    }
}

public struct Episode: Equatable, Sendable {
    public let id: Int
    public let name: String
    public let overview: String
    public let voteAverage: Double
    public let voteCount: Int
    public let airDate: String
    public let episodeNumber: Int
    public let episodeType: String
    public let productionCode: String
    public let runtime: Int?
    public let seasonNumber: Int
    public let showID: Int
    public let stillPath: String?
    public init(
        id: Int,
        name: String,
        overview: String,
        voteAverage: Double,
        voteCount: Int,
        airDate: String,
        episodeNumber: Int,
        episodeType: String,
        productionCode: String,
        runtime: Int?,
        seasonNumber: Int,
        showID: Int,
        stillPath: String?
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.episodeType = episodeType
        self.productionCode = productionCode
        self.runtime = runtime
        self.seasonNumber = seasonNumber
        self.showID = showID
        self.stillPath = stillPath
    }
}

extension ShowDetail {
    public var title: String { name }
    public var originalTitle: String { originalName }
    public var releaseDateText: String { firstAirDate }
    public var runtimeInMinutes: Int? { nil } // Optional: compute from episodes if needed
}

