import Foundation

public enum TMDBRepositoryError: Error {
    case authenticationError(Error)
}

public typealias TMDBRepository = Sendable
