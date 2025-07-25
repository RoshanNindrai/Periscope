import DataModel
import Foundation
import SwiftUI

public struct TMDBImageURLBuilder: Sendable {
    private let configuration: TMDBConfiguration
    
    public init(configuration: TMDBConfiguration) {
        self.configuration = configuration
    }
    
    public func posterImageURL(media: any Media, size: PosterSize) -> URL {
        guard let posterPath = media.posterPath else {
            return URL(string: "htttps://www.google.com")!
        }
        
        return URL(
            string: configuration.images.secureBaseURL
                .appending(size.rawValue)
                .appending(posterPath)
        )!
    }
    
    public func backdropImageURL(media: any Media, size: BackdropSize) -> URL {
        guard let backdropPath = media.backdropPath else {
            return posterImageURL(media: media, size: .w780)
        }
        
        return URL(
            string: configuration.images.secureBaseURL
                .appending(size.rawValue)
                .appending(backdropPath)
        )!
    }
    
    public func profileImageURL(cast: any CastAndCrewMember, size: ProfileSize) -> URL {
        guard let profilePath = cast.profilePath else {
            return URL(string: "htttps://www.google.com")!
        }
        
        return URL(
            string: configuration.images.secureBaseURL
                .appending(size.rawValue)
                .appending(profilePath)
        )!
    }
    
    public func watchProviderImageURL(watchProvider: WatchProvider, size: LogoSize) -> URL {
        let logopath = watchProvider.logoPath
        
        return URL(
            string: configuration.images.secureBaseURL
                .appending(size.rawValue)
                .appending(logopath)
        )!
    }
}

public struct TMDBImageURLBuilderEnvironmentKey: EnvironmentKey {
    public static let defaultValue: TMDBImageURLBuilder = .init(configuration: .default)
}

public extension EnvironmentValues {
    var tmdbImageURLBuilder: TMDBImageURLBuilder {
        get {
            self[TMDBImageURLBuilderEnvironmentKey.self]
        } set {
            self[TMDBImageURLBuilderEnvironmentKey.self] = newValue
        }
    }
}
