/// TMDBAPI defines all the endpoints and configurations for interacting with The Movie Database (TMDB) API.
/// Each case represents a specific API endpoint or authentication step.

import Networking
import Foundation

/// Enum describing TMDB API endpoints and their properties for making network requests.
enum TMDBAPI: API {
    private static let apiBaseURL = URL(string: "https://api.themoviedb.org/3")!
    private static let authBaseURL = URL(string: "https://www.themoviedb.org")!
    
    case configuration
    
    // MARK: - Authentication Endpoints
    case requestToken
    case authorizeToken(requestToken: String)
    case createSession(requestToken: String)
    
    // MARK: - Movie & TV Endpoints
    case nowPlayingMovies
    case popularMovies
    case topRatedMovies
    case popularTVShows
    case upcomingMovies
    case trendingToday

    /// The base URL for the selected TMDB endpoint.
    var baseURL: URL {
        switch self {
        case .configuration, 
             .requestToken, 
             .createSession, 
             .popularMovies, 
             .topRatedMovies, 
             .popularTVShows, 
             .upcomingMovies, 
             .nowPlayingMovies, 
             .trendingToday:
            // All these endpoints share the same API base URL
            return Self.apiBaseURL
        case .authorizeToken:
            // Authorization happens on a different domain
            return Self.authBaseURL
        }
    }
    
    /// The path appended to the baseURL for the endpoint.
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
            // Path includes dynamic request token for authentication
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
    
    /// The HTTP method (GET, POST) to use for this API call.
    var method: HTTPMethod {
        switch self {
        case .configuration, 
             .popularMovies, 
             .requestToken, 
             .authorizeToken, 
             .topRatedMovies, 
             .popularTVShows, 
             .upcomingMovies, 
             .nowPlayingMovies, 
             .trendingToday:
            return .get
        case .createSession:
            return .post
        }
    }
    
    /// The cache policy to use for the URLRequest.
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalCacheData
    }
    
    /// The timeout interval for the URLRequest.
    var timeout: TimeInterval {
        return 30
    }
    
    /// The HTTP headers to include in the request.
    var headers: [String: String] {
        return [
            "Authorization": "Bearer \(Secrets.TMDB_API_KEY)", 
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
    
    /// The query parameters to include in the URL request.
    var queryParameters: [String : String] {
        switch self {
        case .configuration, 
             .popularMovies, 
             .requestToken, 
             .topRatedMovies, 
             .popularTVShows, 
             .upcomingMovies, 
             .nowPlayingMovies, 
             .trendingToday:
            return [:] // No query parameters for these endpoints
        case .authorizeToken:
            // Redirect URL after authorization
            return ["redirect_to": "periscope://auth-callback"]
        case .createSession:
            return [:]
        }
    }
    
    /// The HTTP body to include in the request, if any.
    var body: [String: Any]? {
        switch self {
        case .createSession(let requestToken):
            // Send request token in body to create session
            return ["request_token": requestToken]
        case .configuration, 
             .requestToken, 
             .authorizeToken, 
             .popularMovies, 
             .popularTVShows, 
             .topRatedMovies, 
             .upcomingMovies, 
             .nowPlayingMovies, 
             .trendingToday:
            return nil
        }
    }
}
