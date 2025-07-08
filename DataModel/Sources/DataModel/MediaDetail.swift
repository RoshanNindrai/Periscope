import Foundation

/// A protocol representing detailed information about a media item (movie, TV show, etc.).
public protocol MediaDetail: Equatable, Sendable {
    /// Unique identifier for the media item.
    var id: Int { get }
    /// Title of the media item.
    var title: String { get }
    /// Original title in the original language.
    var originalTitle: String { get }
    /// Brief summary or description of the media item.
    var overview: String { get }
    /// Marketing tagline associated with the media item.
    var tagline: String { get }
    /// Path to the poster image, if available.
    var posterPath: String? { get }
    /// Path to the backdrop image, if available.
    var backdropPath: String? { get }
    /// Homepage URL for the media item, if available.
    var homepage: String? { get }
    /// Current status (e.g., Released, In Production).
    var status: String { get }
    /// Original language code (e.g., "en" for English).
    var originalLanguage: String { get }
    /// Popularity score (often based on user activity).
    var popularity: Double { get }
    /// Average vote or rating (e.g., out of 10).
    var voteAverage: Double { get }
    /// Number of votes or ratings received.
    var voteCount: Int { get }
    /// Genres associated with the media item.
    var genres: [Genre] { get }
    /// Languages spoken in the media item.
    var spokenLanguages: [SpokenLanguage] { get }
    /// Companies that produced the media item.
    var productionCompanies: [ProductionCompany] { get }
    /// Countries where production took place.
    var productionCountries: [ProductionCountry] { get }
    /// Countries of origin (e.g., for international co-productions).
    var originCountry: [String] { get }
    /// Formatted release date as a string.
    var releaseDateText: String { get }
    /// Runtime in minutes, if available.
    var runtimeInMinutes: Int? { get }
}
