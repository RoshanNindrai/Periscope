import DataModel
import Foundation
import TMDBRepository

struct MovieListResponse: Decodable {
    struct Dates: Codable {
        let maximum: String
        let minimum: String
    }
    let dates: Dates?
    let page: Int
    let results: [MovieResponse]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieResponse: Decodable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieListResponse {
    func toDomainModel() -> MediaList {
        .init(
            medias: results.map { $0.toDomainModel() },
            page: page,
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}

extension MovieResponse {
    func toDomainModel() -> Movie {
        Movie(
            adult: adult,
            backdropPath: backdropPath,
            genreIds: genreIds,
            id: id,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}
