import Foundation

@MainActor
public protocol NetworkServiceFactory {
    func makeNetworkService() -> NetworkService
}
