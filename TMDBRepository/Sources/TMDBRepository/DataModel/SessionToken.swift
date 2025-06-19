import Foundation

public struct SessionToken: Sendable {
    public let success: Bool
    public let sessionId: String
    
    public init(success: Bool, sessionId: String) {
        self.success = success
        self.sessionId = sessionId
    }
}
