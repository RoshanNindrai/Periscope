import DataModel
import Foundation
import TMDBRepository

struct TMDBConfigurationResponse: Decodable, Sendable {
    let changeKeys: [String]
    let images: TMDBImageConfigurationResponse

    enum CodingKeys: String, CodingKey {
        case changeKeys = "change_keys"
        case images
    }
}

struct TMDBImageConfigurationResponse: Decodable, Sendable {
    let baseURL: String
    let secureBaseURL: String
    let backdropSizes: [BackdropSize]
    let logoSizes: [LogoSize]
    let posterSizes: [PosterSize]
    let profileSizes: [ProfileSize]
    let stillSizes: [StillSize]

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}

extension TMDBConfigurationResponse {
    func toDomainModel() -> TMDBConfiguration {
        TMDBConfiguration(images: images.toDomainModel())
    }
}

extension TMDBImageConfigurationResponse {
    func toDomainModel() -> TMDBImageConfiguration {
        TMDBImageConfiguration(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: backdropSizes,
            logoSizes: logoSizes,
            posterSizes: posterSizes,
            profileSizes: profileSizes,
            stillSizes: stillSizes
        )
    }
}

extension BackdropSize: @retroactive Decodable {}
extension LogoSize: @retroactive Decodable {}
extension PosterSize: @retroactive Decodable {}
extension ProfileSize: @retroactive Decodable {}
extension StillSize: @retroactive Decodable {}
