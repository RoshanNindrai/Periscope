// Media.swift
// Defines core types for representing movies and TV shows, with common metadata properties.

import Foundation

/// The type of media item, either a Movie or a TV Show.
public enum MediaItemType: Sendable, Equatable {
    /// A feature film.
    case movie
    /// A television show or series.
    case tvShow
    
    /// A human-readable string suitable for display.
    public var description: String {
        switch self {
        case .movie:
            return "Movie"
        case .tvShow:
            return "Tv Show"
        }
    }
}

/// Protocol for any media item, such as a movie or TV show.
public protocol Media: Equatable, Sendable {
    /// Unique identifier for the media item.
    var id: Int { get }
    /// Title of the movie or show.
    var title: String { get }
    /// Whether the item is a movie or TV show.
    var type: MediaItemType { get }
    /// Brief summary of the content.
    var overview: String { get }
    /// The release date in YYYY-MM-DD format.
    var releaseDate: String { get }
    /// Path to the poster image, if available.
    var posterPath: String? { get }
    /// Path to the backdrop image, if available.
    var backdropPath: String? { get }
}

public extension Media {
    /// The release year (first four characters of release date).
    /// Efficiently returns the year prefix, if available.
    var releaseYear: String {
        String(releaseDate.prefix(4))
    }
}
