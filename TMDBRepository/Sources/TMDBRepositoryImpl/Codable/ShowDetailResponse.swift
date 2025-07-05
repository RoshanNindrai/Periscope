import DataModel
import Foundation

struct ShowDetailResponse: Decodable {
    let id: Int
    let name: String
    let originalName: String
    let overview: String
    let tagline: String
    let posterPath: String
    let backdropPath: String
    let homepage: String
    let status: String
    let type: String
    let originalLanguage: String
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let adult: Bool
    let inProduction: Bool
    let firstAirDate: String
    let lastAirDate: String
    let numberOfEpisodes: Int
    let numberOfSeasons: Int

    let genres: [GenreResponse]
    let languages: [String]
    let originCountry: [String]
    let spokenLanguages: [SpokenLanguageResponse]
    let networks: [ShowNetworkResponse]
    let productionCompanies: [ProductionCompanyResponse]
    let productionCountries: [ProductionCountryResponse]
    let createdBy: [CreatorResponse]
    let seasons: [SeasonResponse]

    let lastEpisodeToAir: EpisodeResponse?
    let nextEpisodeToAir: EpisodeResponse?

    enum CodingKeys: String, CodingKey {
        case id, name, overview, status, type, homepage, popularity, adult
        case originalName = "original_name"
        case tagline
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case inProduction = "in_production"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case genres, languages
        case originCountry = "origin_country"
        case spokenLanguages = "spoken_languages"
        case networks
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case createdBy = "created_by"
        case seasons
        case lastEpisodeToAir = "last_episode_to_air"
        case nextEpisodeToAir = "next_episode_to_air"
    }
}

struct ShowNetworkResponse: Decodable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct CreatorResponse: Decodable {
    let id: Int
    let name: String
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, gender
        case profilePath = "profile_path"
    }
}

struct SeasonResponse: Decodable {
    let id: Int
    let name: String
    let overview: String
    let airDate: String?
    let episodeCount: Int
    let posterPath: String?
    let seasonNumber: Int
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}

struct EpisodeResponse: Decodable {
    let id: Int
    let name: String
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let airDate: String
    let episodeNumber: Int
    let episodeType: String
    let productionCode: String
    let runtime: Int?
    let seasonNumber: Int
    let showID: Int
    let stillPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
    }
}

// MARK: - Root Mapping

extension ShowDetailResponse {
    func toDomainModel() -> ShowDetail {
        ShowDetail(
            id: id,
            name: name,
            originalName: originalName,
            overview: overview,
            tagline: tagline,
            posterPath: posterPath,
            backdropPath: backdropPath,
            homepage: homepage,
            status: status,
            type: type,
            originalLanguage: originalLanguage,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount,
            adult: adult,
            inProduction: inProduction,
            firstAirDate: firstAirDate,
            lastAirDate: lastAirDate,
            numberOfEpisodes: numberOfEpisodes,
            numberOfSeasons: numberOfSeasons,
            genres: genres.map { $0.toDomainModel() },
            languages: languages,
            originCountry: originCountry,
            spokenLanguages: spokenLanguages.map { $0.toDomainModel() },
            networks: networks.map { $0.toDomainModel() },
            productionCompanies: productionCompanies.map { $0.toDomainModel() },
            productionCountries: productionCountries.map { $0.toDomainModel() },
            createdBy: createdBy.map { $0.toDomainModel() },
            seasons: seasons.map { $0.toDomainModel() },
            lastEpisodeToAir: lastEpisodeToAir?.toDomainModel(),
            nextEpisodeToAir: nextEpisodeToAir?.toDomainModel()
        )
    }
}


// MARK: - Network Mapping

extension ShowNetworkResponse {
    func toDomainModel() -> ShowNetwork {
        ShowNetwork(
            id: id,
            name: name,
            logoPath: logoPath,
            originCountry: originCountry
        )
    }
}

// MARK: - Creator Mapping

extension CreatorResponse {
    func toDomainModel() -> Creator {
        Creator(
            id: id,
            name: name,
            gender: gender,
            profilePath: profilePath
        )
    }
}

// MARK: - Season Mapping

extension SeasonResponse {
    func toDomainModel() -> Season {
        Season(
            id: id,
            name: name,
            overview: overview,
            airDate: airDate,
            episodeCount: episodeCount,
            posterPath: posterPath,
            seasonNumber: seasonNumber,
            voteAverage: voteAverage
        )
    }
}

// MARK: - Episode Mapping

extension EpisodeResponse {
    func toDomainModel() -> Episode {
        Episode(
            id: id,
            name: name,
            overview: overview,
            voteAverage: voteAverage,
            voteCount: voteCount,
            airDate: airDate,
            episodeNumber: episodeNumber,
            episodeType: episodeType,
            productionCode: productionCode,
            runtime: runtime,
            seasonNumber: seasonNumber,
            showID: showID,
            stillPath: stillPath
        )
    }
}

