import Foundation

public enum MediaDetailCategory: Identifiable, Equatable {
    case mediaDetail(any MediaDetail)
    case castAndCrew(CastList)
    case relatedMedia(MediaList)
    
    public var id: String {
        switch self {
        case .mediaDetail(let mediaDetail):
            return "mediaDetail_\(mediaDetail.id)"
        case .castAndCrew(let castList):
            return "castAndCrew_\(castList.id)"
        case .relatedMedia:
            return "relatedMedia"
        }
    }
    
    public var pageableMediaList: (any PageableMediaList)? {
        switch self {
        case .mediaDetail:
            return nil
        case .castAndCrew:
            return nil
        case .relatedMedia(let mediaList):
            return mediaList
        }
    }
    
    public var mediaItems: [any Media]? {
        switch self {
        case .mediaDetail:
            return nil
        case .castAndCrew:
            return nil
        case .relatedMedia(let mediaList):
            return mediaList.items
        }
    }
    
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
    
    public static func == (lhs: MediaDetailCategory, rhs: MediaDetailCategory) -> Bool {
        switch (lhs, rhs) {
        case (.mediaDetail(let l), .mediaDetail(let r)):
            return l.id == r.id
        case (.castAndCrew(let l), .castAndCrew(let r)):
            return l == r
        case (.relatedMedia(let l), .relatedMedia(let r)):
            return l == r
        default:
            return false
        }
    }
}
