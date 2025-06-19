import Foundation

/// Represents the supported HTTP methods for network requests.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

/// Protocol defining the necessary properties for an API endpoint.
public protocol API: Sendable {
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
    
    /// The query parameter attached with the request
    var queryParameters: [String: String] { get }
    
    /// The body to attach to the request (for POST, PUT, etc.)
    var body: [String: Any]? { get }
    
    /// The headers to attach to the request
    var headers: [String: String] { get }
}

// MARK: - Optional conformance

public extension API {
    var queryParameters: [String: String] {
        [:]
    }
    
    var body: [String: Any]? {
        nil
    }
    
    var headers: [String: String] {
        [:]
    }
}

public extension API {
    /// Converts the API definition into a `URLRequest` object.
    /// - Returns: A configured `URLRequest`.
    func toURLRequest() -> URLRequest {
        
        let urlWithPath = baseURL.appending(path: path)
        
        var components = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: false)
        
        if !queryParameters.isEmpty {
            components?.queryItems = queryParameters.map(URLQueryItem.init)
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
        
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                fatalError("Failed to serialize body to JSON: \(error)")
            }
        }
        
        for (headerField, headerValue) in headers {
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        
        return urlRequest
    }
}
