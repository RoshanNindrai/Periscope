import Foundation

/// Represents a Model that can be fetched within the application.
public struct NetworkResponse<Resource: Decodable> {
    public let resource: Resource
    public let cacheExpiryDate: Date?
}

/// Error that might occur while executing a request at Client / Server end.
public enum NetworkServiceError: Error {
    case invalidRequestURL
    case requestFailed(Error)
}

/// Network service responsible for dispatching API request
public protocol NetworkService {

    /// Dispatches a Network DataRequest for a given API request.
    /// - Parameters:
    ///   - apiRequest: The API request that is executed by the service.
    func perform<Resource: Decodable>(
        apiRequest: API
    ) async throws -> NetworkResponse<Resource>
    
    /// Dispatches a Network DataRequest to get raw data
    /// - Parameters:
    ///   - url: The url to the Asset
    func fetchData(
        from url: URL
    ) async throws -> Data
}
