import DataModel
import Foundation
import TMDBRepository

struct MediaResultSetResponse: Decodable {
    let page: Int
    let results: [MediaItemResponse]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

enum MediaItemResponse: Decodable {
    case movie(MovieResponse)
    case tvShow(TVShowResponse)

    enum TrendingMediaType: String, Decodable {
        case movie
        case tv
    }

    private enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(TrendingMediaType.self, forKey: .mediaType)
        let singleValueContainer = try decoder.singleValueContainer()

        switch mediaType {
        case .movie:
            let movie = try singleValueContainer.decode(MovieResponse.self)
            self = .movie(movie)
        case .tv:
            let tvShow = try singleValueContainer.decode(TVShowResponse.self)
            self = .tvShow(tvShow)
        }
    }
}

extension MediaResultSetResponse {
    func toDomainModel() -> TrendingMediaList {
        TrendingMediaList(
            page: page,
            items: results.compactMap { $0.toDomainModel() },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}

extension MediaItemResponse {
    func toDomainModel() -> TrendingItem {
        switch self {
        case .movie(let movie):
            return .movie(movie.toDomainModel())
        case .tvShow(let tvShow):
            return .tvShow(tvShow.toDomainModel())
        }
    }
}
