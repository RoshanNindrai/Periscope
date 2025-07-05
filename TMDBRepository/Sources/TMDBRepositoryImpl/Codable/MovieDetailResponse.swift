import DataModel
import Foundation

struct MovieDetailResponse: Decodable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: CollectionInfoResponse?
    let budget: Int
    let genres: [GenreResponse]
    let homepage: String?
    let id: Int
    let imdbID: String?
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompanyResponse]
    let productionCountries: [ProductionCountryResponse]
    let releaseDate: String
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguageResponse]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct CollectionInfoResponse: Decodable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct GenreResponse: Codable {
    let id: Int
    let name: String
}

struct ProductionCompanyResponse: Decodable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

struct ProductionCountryResponse: Decodable {
    let iso3166_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

struct SpokenLanguageResponse: Decodable {
    let englishName: String
    let iso639_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

// MARK: - MovieDetail Mapping

extension MovieDetailResponse {
    func toDomainModel() -> MovieDetail {
        MovieDetail(
            adult: adult,
            backdropPath: backdropPath,
            belongsToCollection: belongsToCollection?.toDomainModel(),
            budget: budget,
            genres: genres.map { $0.toDomainModel() },
            homepage: homepage,
            id: id,
            imdbID: imdbID,
            originCountry: originCountry,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            productionCompanies: productionCompanies.map { $0.toDomainModel() },
            productionCountries: productionCountries.map { $0.toDomainModel() },
            releaseDate: releaseDate,
            revenue: revenue,
            runtime: runtime,
            spokenLanguages: spokenLanguages.filter(\.name.isEmpty).map { $0.toDomainModel() },
            status: status,
            tagline: tagline,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}

// MARK: - CollectionInfo Mapping

extension CollectionInfoResponse {
    func toDomainModel() -> CollectionInfo {
        CollectionInfo(
            id: id,
            name: name,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }
}

// MARK: - Genre Mapping

extension GenreResponse {
    func toDomainModel() -> Genre {
        Genre(id: id, name: name)
    }
}

// MARK: - ProductionCompany Mapping

extension ProductionCompanyResponse {
    func toDomainModel() -> ProductionCompany {
        ProductionCompany(
            id: id,
            logoPath: logoPath,
            name: name,
            originCountry: originCountry
        )
    }
}

// MARK: - ProductionCountry Mapping

extension ProductionCountryResponse {
    func toDomainModel() -> ProductionCountry {
        ProductionCountry(
            iso3166_1: iso3166_1,
            name: name
        )
    }
}

// MARK: - SpokenLanguage Mapping

extension SpokenLanguageResponse {
    func toDomainModel() -> SpokenLanguage {
        SpokenLanguage(
            englishName: englishName,
            iso639_1: iso639_1,
            name: name
        )
    }
}
