
public protocol Media: Sendable, Equatable {
    var id: Int { get }
    var title: String { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }
}
