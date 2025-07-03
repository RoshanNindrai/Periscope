import Foundation

public struct RequestToken: Equatable, Sendable {
    public let success: Bool
    public let expiresAt: String
    public let requestToken: String
    
    public init(
        success: Bool,
        expiresAt: String,
        requestToken: String
    ) {
        self.success = success
        self.expiresAt = expiresAt
        self.requestToken = requestToken
    }
}
