import Foundation

public protocol MediaDetail: Equatable, Sendable {
    var id: Int { get }
    var title: String { get }
    var originalTitle: String { get }
    var overview: String { get }
    var tagline: String { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }
    var homepage: String? { get }
    var status: String { get }
    var originalLanguage: String { get }
    var popularity: Double { get }
    var voteAverage: Double { get }
    var voteCount: Int { get }
    var genres: [Genre] { get }
    var spokenLanguages: [SpokenLanguage] { get }
    var productionCompanies: [ProductionCompany] { get }
    var productionCountries: [ProductionCountry] { get }
    var originCountry: [String] { get }

    var releaseDateText: String { get }
    var runtimeInMinutes: Int? { get }
}
