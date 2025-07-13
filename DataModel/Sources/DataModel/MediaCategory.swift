// MediaCategory.swift
// Defines categories of media items for display and navigation.

import Foundation

/// Represents a category of media in the app, such as popular movies, now playing movies, upcoming movies,
/// popular TV shows, top rated movies, and trending media today.
/// Each category holds an underlying list of media items to display and manage.
public enum MediaCategory: Identifiable, Equatable, Sendable {
    /// Popular movies category.
    case popularMovies(MediaList)
    /// Currently playing movies in theaters.
    case nowPlaying(MediaList)
    /// Upcoming movies category.
    case upcoming(MediaList)
    /// Popular TV shows category.
    case popularTVShows(MediaList)
    /// Top rated movies category.
    case topRated(MediaList)
    /// Trending media today (could be movies or shows).
    case trendingToday(TrendingMediaList)
    
    /// Unique identifier for the category (for use in SwiftUI lists, etc.).
    public var id: String {
        switch self {
        case .popularMovies:
            return "popularMovies"
        case .nowPlaying:
            return "nowPlaying"
        case .upcoming:
            return "upcoming"
        case .popularTVShows:
            return "popularTVShows"
        case .topRated:
            return "topRated"
        case .trendingToday:
            return "trendingToday"
        }
    }
    
    /// Returns the underlying pageable list for the category.
    public var pageableMediaList: any PageableMediaList {
        return listValue()
    }
    
    /// Returns the array of media items for this category.
    public var mediaItems: [any Media] {
        switch self.listValue() {
        case let list as MediaList:
            return list.items
        case let resultSet as TrendingMediaList:
            return resultSet.items
        default:
            return []
        }
    }
    
    /// The display title for this category.
    public var title: String {
        switch self {
        case .popularMovies:
            return "Popular Movies"
        case .nowPlaying:
            return "In Theatres Now"
        case .upcoming:
            return "Upcoming Movies"
        case .popularTVShows:
            return "Popular TV Shows"
        case .topRated:
            return "Top Rated Movies"
        case .trendingToday:
            return "Trending Today"
        }
    }
    
    /// Equatable conformance for comparing two categories.
    public static func == (lhs: MediaCategory, rhs: MediaCategory) -> Bool {
        switch (lhs, rhs) {
        case let (.popularMovies(l), .popularMovies(r)):
            return l == r
        case let (.nowPlaying(l), .nowPlaying(r)):
            return l == r
        case let (.upcoming(l), .upcoming(r)):
            return l == r
        case let (.popularTVShows(l), .popularTVShows(r)):
            return l == r
        case let (.topRated(l), .topRated(r)):
            return l == r
        case let (.trendingToday(l), .trendingToday(r)):
            return l == r
        default:
            return false
        }
    }
    
    // MARK: - Private Helpers
    
    /// Private helper to extract the underlying pageable list or result set for the category.
    /// This method returns the associated value for each case as a `any PageableMediaList`.
    private func listValue() -> any PageableMediaList {
        switch self {
        case .popularMovies(let list):
            return list
        case .nowPlaying(let list):
            return list
        case .upcoming(let list):
            return list
        case .popularTVShows(let list):
            return list
        case .topRated(let list):
            return list
        case .trendingToday(let list):
            return list
        }
    }
}
