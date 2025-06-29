import Networking
import Foundation

enum TMDBAPI: API {
    case configuration
    // MARK: - Authentication
    case requestToken
    case authorizeToken(requestToken: String)
    case createSession(requestToken: String)
    
    case nowPlayingMovies
    case popularMovies
    case topRatedMovies
    case popularTVShows
    case upcomingMovies
    case trendingToday

    var baseURL: URL {
        switch self {
        case .configuration, .requestToken, .createSession, .popularMovies, .topRatedMovies, .popularTVShows, .upcomingMovies, .nowPlayingMovies, .trendingToday:
            return URL(string: "https://api.themoviedb.org/3")!
        case .authorizeToken:
            return URL(string: "https://www.themoviedb.org")!
        }
    }
    
    var path: String {
        switch self {
        case .configuration:
            return "/configuration"
        case .popularMovies:
            return "/movie/popular"
        case .popularTVShows:
            return "/tv/popular"
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
        case .trendingToday:
            return "/trending/all/day"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .configuration, .popularMovies, .requestToken, .authorizeToken, .topRatedMovies, .popularTVShows, .upcomingMovies, .nowPlayingMovies, .trendingToday:
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
        case .configuration, .popularMovies, .requestToken, .topRatedMovies, .popularTVShows, .upcomingMovies, .nowPlayingMovies, .trendingToday:
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
        case .configuration, .requestToken, .authorizeToken, .popularMovies, .popularTVShows, .topRatedMovies, .upcomingMovies, .nowPlayingMovies, .trendingToday:
            return nil
        }
    }
}
