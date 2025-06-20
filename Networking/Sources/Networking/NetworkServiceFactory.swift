import Foundation

public protocol NetworkServiceFactory: Sendable {
    func makeNetworkService() -> NetworkService
}
