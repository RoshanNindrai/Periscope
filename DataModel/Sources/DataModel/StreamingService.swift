import Foundation
import UIKit

public enum StreamingService: String, CaseIterable {
    case netflix
    case primeVideo
    case hboMax

    public var hostIdentifiers: [String] {
        switch self {
        case .netflix: return ["netflix.com"]
        case .primeVideo: return ["primevideo.com", "amazon.com"]
        case .hboMax: return ["hbomax.com", "max.com"]
        }
    }

    public var appScheme: String {
        switch self {
        case .netflix: return "nflx"
        case .primeVideo: return "aiv"
        case .hboMax: return "hbomax"
        }
    }

    public var deeplinkBasePath: String {
        switch self {
        case .netflix: return "/www.netflix.com/title/"
        case .primeVideo: return "/aiv/view?asin="
        case .hboMax: return "/title/"
        }
    }

    public var fallbackWebURL: String {
        switch self {
        case .netflix: return "https://www.netflix.com"
        case .primeVideo: return "https://www.primevideo.com"
        case .hboMax: return "https://www.max.com"
        }
    }
}

public extension MediaDetail {
    /// Returns the matching streaming service based on homepage host
    var streamingService: StreamingService? {
        guard let homepage,
              let host = URL(string: homepage)?.host?.lowercased() else {
            return nil
        }

        return StreamingService.allCases.first {
            $0.hostIdentifiers.contains(where: host.contains)
        }
    }

    /// Returns the appropriate app deeplink URL for the media
    var streamingAppDeeplink: URL? {
        guard let service = streamingService,
              let homepage,
              let pathComponent = URL(string: homepage)?
                    .path
                    .split(separator: "/")
                    .last
        else {
            return nil
        }

        switch service {
        case .primeVideo:
            var components = URLComponents()
            components.scheme = service.appScheme
            components.host = "aiv"
            components.path = "/view"
            components.queryItems = [
                URLQueryItem(name: "asin", value: String(pathComponent))
            ]
            return components.url

        case .netflix:
            // Expected format: nflx://www.netflix.com/title/{id}
            let urlString = "\(service.appScheme)://www.netflix.com/title/\(pathComponent)"
            return URL(string: urlString)

        case .hboMax:
            var components = URLComponents()
            components.scheme = service.appScheme
            components.path = service.deeplinkBasePath + pathComponent
            return components.url
        }
    }

    /// Returns a fallback web URL if no app deeplink is available
    var streamingWebFallbackURL: URL? {
        guard let homepage = homepage,
              let url = URL(string: homepage) else {
            return streamingService.flatMap { URL(string: $0.fallbackWebURL) }
        }
        return url
    }
}
