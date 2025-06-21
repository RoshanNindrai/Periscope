import Networking
import Foundation

enum TMDBAPI: API {
    // MARK: - Authentication
    case requestToken
    case authorizeToken(requestToken: String)
    case createSession(requestToken: String)
    
    case nowPlayingMovies
    case popularMovies
    case topRatedMovies
    case upcomingMovies

    var baseURL: URL {
        switch self {
        case .requestToken, .createSession, .popularMovies, .topRatedMovies, .upcomingMovies, .nowPlayingMovies:
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
        case .topRatedMovies:
            return "/movie/top_rated"
        case .upcomingMovies:
            return "/movie/upcoming"
        case .nowPlayingMovies:
            return "/movie/now_playing"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popularMovies, .requestToken, .authorizeToken, .topRatedMovies, .upcomingMovies, .nowPlayingMovies:
            return .get
        case .createSession:
            return .post
        }
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalCacheData
    }
    
    var timeout: TimeInterval {
        return 30
    }
    
    var headers: [String: String] {
        return [
            "Authorization": "Bearer \(Secrets.TMDB_API_KEY)", 
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
    
    var queryParameters: [String : String] {
        switch self {
        case .popularMovies, .requestToken, .topRatedMovies, .upcomingMovies, .nowPlayingMovies:
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
        case .requestToken, .authorizeToken, .popularMovies, .topRatedMovies, .upcomingMovies, .nowPlayingMovies:
            return nil
        }
    }
}
