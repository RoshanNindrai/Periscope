import Foundation

public protocol Media: Equatable, Sendable {
    var id: Int { get }
    var title: String { get }
    var releaseDate: String { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }
}
