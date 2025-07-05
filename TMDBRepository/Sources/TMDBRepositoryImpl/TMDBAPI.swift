/// TMDBAPI defines all the endpoints and configurations for interacting with The Movie Database (TMDB) API.
/// Each case represents a specific API endpoint or authentication step.

import Networking
import Foundation

/// Enum describing TMDB API endpoints and their properties for making network requests.
enum TMDBAPI: API {
    private static let apiBaseURL = URL(string: "https://api.themoviedb.org/3")!
    private static let authBaseURL = URL(string: "https://www.themoviedb.org")!
    
    private static let defaultHeaders: [String: String] = [
        "Authorization": "Bearer \(Secrets.TMDB_API_KEY)",
        "Content-Type": "application/json;charset=utf-8"
    ]
    
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
    case relatedMovies(id: Int)
    case movieCredits(id: Int)
    case tvCredits(id: Int)
    case relatedTVShows(id: Int)
    case movieDetails(id: Int)
    case tvDetails(id: Int)

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
             .trendingToday,
             .relatedMovies,
             .relatedTVShows,
             .movieCredits,
             .tvCredits,
             .movieDetails,
             .tvDetails:
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
        case .relatedMovies(let id):
            return "/movie/\(id)/similar"
        case .relatedTVShows(let id):
            return "/tv/\(id)/similar"
        case .movieCredits(let id):
            return "/movie/\(id)/credits"
        case .tvCredits(let id):
            return "/tv/\(id)/credits"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .tvDetails(let id):
            return "/tv/\(id)"
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
             .trendingToday,
             .relatedMovies,
             .relatedTVShows,
             .movieCredits,
             .tvCredits,
             .movieDetails,
             .tvDetails:
            return .get
        case .createSession:
            return .post
        }
    }
    
    /// The cache policy to use for the URLRequest.
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        // Example: in future, you could set .returnCacheDataElseLoad for certain endpoints
        default:
            return .reloadIgnoringLocalCacheData
        }
    }
    
    /// The timeout interval for the URLRequest.
    var timeout: TimeInterval {
        switch self {
        // Example: in future, you could use a different timeout per endpoint
        default:
            return 30
        }
    }
    
    /// The HTTP headers to include in the request.
    var headers: [String: String] {
        return Self.defaultHeaders
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
             .trendingToday,
             .relatedMovies,
             .relatedTVShows,
             .movieCredits,
             .tvCredits,
             .movieDetails,
             .tvDetails:
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
             .trendingToday,
             .relatedMovies,
             .relatedTVShows,
             .movieCredits,
             .tvCredits,
             .movieDetails,
             .tvDetails:
            return nil
        }
    }
}
