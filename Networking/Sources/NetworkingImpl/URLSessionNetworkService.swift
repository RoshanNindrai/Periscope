import Foundation
import Networking

private typealias RawNetworkResponse = (data: Data, response: HTTPURLResponse?)

private enum HTTPHeaderKey {
    static let cacheControl = "Cache-Control"
}

/// A network service handling JSON requests via URLSession.
///
/// This service performs asynchronous network requests to fetch JSON-encoded data from APIs, decodes the response,
/// and extracts cache expiration information from HTTP headers. It is designed for stateless, testable use.
public struct URLSessionNetworkService: NetworkService {
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    /// Initializes the service with a default ephemeral URLSession configuration.
    /// Cache is disabled, and all requests ignore the local cache.
    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        let session = URLSession(configuration: configuration)
        
        self.init(session: session)
    }
    
    /// Initializes the service with a custom URLSession. Intended for dependency injection and testing.
    init(session: URLSession) {
        self.session = session
    }
    
    /// Executes a network request defined by the given API, decodes the JSON response into the provided Decodable type,
    /// and returns both the decoded resource and an optional cache expiry date parsed from the response headers.
    /// - Parameter apiRequest: The API endpoint to request.
    /// - Returns: A NetworkResponse containing the decoded resource and cache expiry date.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    public func perform<Resource>(
        apiRequest: API
    ) async throws -> NetworkResponse<Resource> where Resource: Decodable {
        do {
            let (data, response) = try await dispatch(request: apiRequest.toURLRequest())
            let resource = try self.decoder.decode(Resource.self, from: data)
            let cacheExpiryDate = self.extractCacheExpiry(from: response)
            
            return .init(resource: resource, cacheExpiryDate: cacheExpiryDate)
        } catch let error as NetworkServiceError {
            // Rethrow if the error is already a NetworkServiceError
            throw error
        } catch {
            // Wrap any other error as a requestFailed NetworkServiceError
            throw NetworkServiceError.requestFailed(error)
        }
    }
    
    /// Performs a simple data fetch from the provided URL.
    /// - Parameter url: The resource URL.
    /// - Returns: The raw Data returned by the server.
    /// - Throws: An error if the request fails.
    public func fetchData(
        from url: URL
    ) async throws -> Data {
        do {
            let (data, _) = try await dispatch(request: URLRequest(url: url))
            return data
        } catch let error as NetworkServiceError {
            // Rethrow if the error is already a NetworkServiceError
            throw error
        } catch {
            // Wrap any other error as a requestFailed NetworkServiceError
            throw NetworkServiceError.requestFailed(error)
        }
    }
}

private extension URLSessionNetworkService {
    /// Sends a URLRequest using URLSession and returns the response data and HTTPURLResponse.
    /// - Parameter request: The request to perform.
    /// - Returns: Tuple containing data and optional HTTPURLResponse.
    /// - Throws: An error if the network request fails.
    func dispatch(request: URLRequest) async throws -> RawNetworkResponse {
        do {
            let (data, response) = try await session.data(for: request)
            return (data, response as? HTTPURLResponse)
        } catch let error as NetworkServiceError {
            // Rethrow if the error is already a NetworkServiceError
            throw error
        } catch {
            // Wrap any other error as a requestFailed NetworkServiceError
            throw NetworkServiceError.requestFailed(error)
        }
    }
    
    /// Parses the "Cache-Control" header for a max-age value and calculates the cache expiry date.
    /// - Parameter response: The HTTPURLResponse to parse.
    /// - Returns: The expiry Date if present, otherwise nil.
    func extractCacheExpiry(from response: HTTPURLResponse?) -> Date? {
        guard let cacheControl = response?.value(forHTTPHeaderField: HTTPHeaderKey.cacheControl),
              let maxAgeString = cacheControl.split(separator: "=").last,
              let maxAgeSeconds = TimeInterval(maxAgeString) else {
            return nil
        }
        return Date().addingTimeInterval(maxAgeSeconds)
    }
}
