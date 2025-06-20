import Foundation
import Networking
import NetworkingImpl

public struct DefaultNetworkServiceFactory: NetworkServiceFactory {
    public func makeNetworkService() -> any NetworkService {
        URLSessionNetworkService()
    }
}
