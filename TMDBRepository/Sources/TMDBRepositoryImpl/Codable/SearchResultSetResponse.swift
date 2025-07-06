import DataModel
import Foundation

// MARK: - Root Response
struct SearchResultSetResponse: Decodable {
    let page: Int
    let results: [SearchResultItemResponse]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Enum Wrapper for Media Items
enum SearchResultItemResponse: Decodable {
    case movie(MovieResponse)
    case tvShow(TVShowResponse)
    case person(PersonResponse)

    enum MediaType: String, Decodable {
        case movie
        case tv
        case person
    }

    private enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        let singleValueContainer = try decoder.singleValueContainer()

        switch mediaType {
        case .movie:
            self = .movie(try singleValueContainer.decode(MovieResponse.self))
        case .tv:
            self = .tvShow(try singleValueContainer.decode(TVShowResponse.self))
        case .person:
            self = .person(try singleValueContainer.decode(PersonResponse.self))
        }
    }
}

// MARK: - Person
struct PersonResponse: Decodable {
    let adult: Bool
    let id: Int
    let name: String
    let originalName: String?
    let mediaType: String
    let popularity: Double
    let gender: Int?
    let knownForDepartment: String?
    let profilePath: String?
    let knownFor: [KnownForResponse]

    enum CodingKeys: String, CodingKey {
        case adult
        case id
        case name
        case originalName = "original_name"
        case mediaType = "media_type"
        case popularity
        case gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

// MARK: - Known For (inside Person)
struct KnownForResponse: Decodable {
    let id: Int
    let mediaType: String
    let title: String?
    let name: String?
    let originalTitle: String?
    let originalName: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let originalLanguage: String?
    let genreIds: [Int]
    let popularity: Double
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case title
        case name
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension SearchResultSetResponse {
    func toDomainModel() -> SearchResultSet {
        SearchResultSet(
            page: page,
            items: results.compactMap { $0.toDomainModel() },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}

extension PersonResponse {
    func toDomainModel() -> Person {
        Person(
            adult: adult,
            id: id,
            name: name,
            originalName: originalName,
            mediaType: mediaType,
            popularity: popularity,
            gender: gender,
            knownForDepartment: knownForDepartment,
            profilePath: profilePath
        )
    }
}

extension SearchResultItemResponse {
    func toDomainModel() -> SearchItem {
        switch self {
        case .movie(let movie):
            return .movie(movie.toDomainModel())
        case .tvShow(let tvShow):
            return .tvShow(tvShow.toDomainModel())
        case .person(let person):
            return .person(person.toDomainModel())
        }
    }
}
