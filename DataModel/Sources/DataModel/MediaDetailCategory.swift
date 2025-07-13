// MediaDetailCategory.swift
//
// Defines content categories in a media detail view (e.g., Details, Cast & Crew, Related),
// each with associated payloads for unified UI and logic handling. Efficiently exposes identity, paging, and display info.

import Foundation

/// Represents a category in a media detail UI, such as Details, Cast & Crew, or Related, each holding its relevant model.
public enum MediaDetailCategory: Identifiable, Equatable, Sendable {
    /// Main media details (e.g., synopsis, ratings). Holds any MediaDetail model.
    case mediaDetail(any MediaDetail)
    /// Cast and crew list for the media.
    case castAndCrew(CastAndCrewList)
    /// Related media items as suggestions.
    case relatedMedia(MediaList)
    
    /// Unique identifier for diffing/UI, combining type and model identity.
    public var id: String {
        switch self {
        case .mediaDetail(let mediaDetail):
            // Prefix guarantees uniqueness across types, even with same underlying ids.
            return "mediaDetail_\(mediaDetail.id)"
        case .castAndCrew(let castList):
            return "castAndCrew_\(castList.id)"
        case .relatedMedia:
            // Section-level identity for related media.
            return "relatedMedia"
        }
    }
    
    /// Returns pageable model if supported (only for related media). Nil otherwise. No allocation if unavailable.
    public var pageableMediaList: (any PageableMediaList)? {
        switch self {
        case .mediaDetail, .castAndCrew:
            // Only related media supports paging.
            return nil
        case .relatedMedia(let mediaList):
            return mediaList
        }
    }
    
    /// The array of media items for display (only in related media). Nil for others. Fast, no copy.
    public var mediaItems: [any Media]? {
        switch self {
        case .mediaDetail, .castAndCrew:
            // No items for detail/cast.
            return nil
        case .relatedMedia(let mediaList):
            return mediaList.items
        }
    }
    
    /// User-visible display title for the section.
    public var title: String {
        switch self {
        case .mediaDetail:
            return "Details"
        case .castAndCrew:
            return "Cast & Crew"
        case .relatedMedia:
            return "Related"
        }
    }
    
    /// Equatable by semantic identity: MediaDetail by id, others by value.
    public static func == (lhs: MediaDetailCategory, rhs: MediaDetailCategory) -> Bool {
        switch (lhs, rhs) {
        case (.mediaDetail(let l), .mediaDetail(let r)):
            // Compare MediaDetail by id for efficiency.
            return l.id == r.id
        case (.castAndCrew(let l), .castAndCrew(let r)):
            // Use CastAndCrewList's Equatable.
            return l == r
        case (.relatedMedia(let l), .relatedMedia(let r)):
            return l == r
        default:
            // Different categories never equal.
            return false
        }
    }
}
