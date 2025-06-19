import Networking
import Foundation

enum TMDBAPI: API {
    // MARK: - Authentication
    case requestToken
    case authorizeToken(requestToken: String)
    case createSession(requestToken: String)
    
    case popularMovies

    var baseURL: URL {
        switch self {
        case .requestToken, .createSession, .popularMovies:
            return URL(string: "https://api.themoviedb.org/3")!
        case .authorizeToken:
            return URL(string: "https://www.themoviedb.org")!
        }
    }
    
    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .requestToken:
            return "/authentication/token/new"
        case .authorizeToken(let requestToken):
            return "/authenticate/\(requestToken)"
        case .createSession:
            return "/authentication/session/new"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popularMovies, .requestToken, .authorizeToken:
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
    
    var headers: [String: String] {
        return [
            "Authorization": "Bearer \(Secrets.TMDB_API_KEY)", 
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
    
    var queryParameters: [String : String] {
        switch self {
        case .popularMovies, .requestToken:
            return [:]
        case .authorizeToken:
            return ["redirect_to": "periscope://auth-callback"]
        case .createSession:
            return [:]
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .createSession(let requestToken):
            return ["request_token": requestToken]
        case .requestToken, .authorizeToken, .popularMovies:
            return nil
        }
    }
}
