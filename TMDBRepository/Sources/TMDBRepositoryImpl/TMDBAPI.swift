import Networking
import Foundation

enum TMDBAPI: API {
    // MARK: - Authentication
    case requestToken
    case authorizeToken(requestToken: String)
    case createSession(requestToken: String)
    
    case popularMovies

    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .requestToken:
            return "/authentication/token/new"
        case .authorizeToken:
            // TODO: TMDB uses a web URL for user authorization, this path is a placeholder
            return "/authenticate/{requestToken}"
        case .createSession:
            return "/authentication/session/new"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popularMovies:
            return .get
        case .requestToken:
            return .get
        case .authorizeToken:
            // TODO: This is generally a web GET request for user authorization, stubbed as .get here
            return .get
        case .createSession:
            return .post
        }
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        case .popularMovies, .requestToken, .authorizeToken, .createSession:
            return .reloadIgnoringLocalCacheData
        }
    }
    
    var timeout: TimeInterval {
        switch self {
        case .popularMovies, .requestToken, .authorizeToken, .createSession:
            return 30
        }
    }
    
    var queryParameters: [String : String] {
        switch self {
        case .popularMovies, .requestToken:
            return [:]
        case .authorizeToken:
            return [:]
        case .createSession:
            return [:]
        }
    }
}
