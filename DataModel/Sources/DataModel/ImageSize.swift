/// Defines image size categories for various image types, typically used in image APIs (e.g., TMDB).
import Foundation

/// Represents all possible image sizes for generic images.
public enum ImageSize: String, CaseIterable, Sendable {
    case w45 = "w45"      // Very small (thumbnail)
    case w92 = "w92"      // Small (thumbnail)
    case w154 = "w154"    // Small/medium
    case w185 = "w185"    // Medium
    case w300 = "w300"    // Large
    case w500 = "w500"    // Larger
    case w780 = "w780"    // Extra large
    case w1280 = "w1280"  // Ultra large
    case h632 = "h632"    // Height based (typically for profiles)
    case w342 = "w342"    // Medium-large
    case original = "original" // Full resolution
}

/// Represents possible sizes for backdrop images (large background banners).
public enum BackdropSize: String, CaseIterable, Sendable {
    case w300     // Small
    case w780     // Medium
    case w1280    // Large
    case original // Full resolution
}

/// Represents possible sizes for logo images.
public enum LogoSize: String, CaseIterable, Sendable {
    case w45      // Very small
    case w92      // Small
    case w154     // Small/medium
    case w185     // Medium
    case w300     // Large
    case w500     // Extra large
    case original // Full resolution
}

/// Represents possible sizes for poster images.
public enum PosterSize: String, CaseIterable, Sendable {
    case w92      // Small
    case w154     // Small/medium
    case w185     // Medium
    case w342     // Medium-large
    case w500     // Large
    case w780     // Extra large
    case original // Full resolution
}

/// Represents possible sizes for profile images (people, actors, etc.).
public enum ProfileSize: String, CaseIterable, Sendable {
    case w45      // Very small
    case w185     // Medium
    case h632     // Tall profile
    case original // Full resolution
}

/// Represents possible sizes for still images (scene stills, etc.).
public enum StillSize: String, CaseIterable, Sendable {
    case w92      // Small
    case w185     // Medium
    case w300     // Large
    case original // Full resolution
}
