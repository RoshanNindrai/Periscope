import Foundation

/// Represents the supported HTTP methods for network requests.
public enum HTTPMethod: String {
    case get = "GET"
}

/// Protocol defining the necessary properties for an API endpoint.
public protocol API {
    /// The base URL of the API.
    var baseURL: URL { get }
    
    /// The endpoint path relative to the base URL.
    var path: String { get }
    
    /// The HTTP method used for the request.
    var method: HTTPMethod { get }
    
    /// The caching policy for the request.
    var cachePolicy: URLRequest.CachePolicy { get }
    
    /// The timeout interval for the request.
    var timeout: TimeInterval { get }
    
    /// The query paramenter attached with the request
    var queryParamenters: [String: String] { get }
}

// MARK: - Optional conformance

public extension API {
    var queryParamenters: [String: String] {
        [:]
    }
}

extension API {
    /// Converts the API definition into a `URLRequest` object.
    /// - Returns: A configured `URLRequest`.
    func toURLRequest() -> URLRequest {
        
        let urlWithPath = baseURL.appending(path: path)
        
        var components = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: false)
        
        if !queryParamenters.isEmpty {
            // We don't want the trailling `?`
            components?.queryItems = queryParamenters.map(URLQueryItem.init)
        }
        
        guard let finalURL = components?.url else {
            fatalError("Invalid URL") // TODO: Log to Bugsnag
        }
        
        var urlRequest = URLRequest(
            url: finalURL,
            cachePolicy: cachePolicy,
            timeoutInterval: timeout
        )
        
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
