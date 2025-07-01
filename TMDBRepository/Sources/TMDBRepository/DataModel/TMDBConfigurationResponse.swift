import DataModel
import Foundation

public struct TMDBConfiguration: Sendable {
    public let images: TMDBImageConfiguration
    
    public init(images: TMDBImageConfiguration) {
        self.images = images
    }
}

public struct TMDBImageConfiguration: Sendable {
    public let baseURL: String
    public let secureBaseURL: String
    public let backdropSizes: [BackdropSize]
    public let logoSizes: [LogoSize]
    public let posterSizes: [PosterSize]
    public let profileSizes: [ProfileSize]
    public let stillSizes: [StillSize]
    
    public init(
        baseURL: String,
        secureBaseURL: String,
        backdropSizes: [BackdropSize],
        logoSizes: [LogoSize],
        posterSizes: [PosterSize],
        profileSizes: [ProfileSize],
        stillSizes: [StillSize]
    ) {
        self.baseURL = baseURL
        self.secureBaseURL = secureBaseURL
        self.backdropSizes = backdropSizes
        self.logoSizes = logoSizes
        self.posterSizes = posterSizes
        self.profileSizes = profileSizes
        self.stillSizes = stillSizes
    }
}

public extension TMDBImageConfiguration {
    static let `default` = TMDBImageConfiguration(
        baseURL: "http://image.tmdb.org/t/p/",
        secureBaseURL: "https://image.tmdb.org/t/p/",
        backdropSizes: [.w300, .w780, .w1280, .original],
        logoSizes: [.w45, .w92, .w154, .w185, .w300, .w500, .original],
        posterSizes: [.w92, .w154, .w185, .w342, .w500, .w780, .original],
        profileSizes: [.w45, .w185, .h632, .original],
        stillSizes: [.w92, .w185, .w300, .original]
    )
}

public extension TMDBConfiguration {
    static let `default` = TMDBConfiguration(images: .default)
}
