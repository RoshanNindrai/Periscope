import DataModel

public struct MediaSelection: Hashable {
    public let media: any Media
    public let key: String
    
    public init(media: any Media, key: String) {
        self.media = media
        self.key = key
    }

    public static func == (lhs: MediaSelection, rhs: MediaSelection) -> Bool {
        return lhs.key == rhs.key && lhs.media.id == rhs.media.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(media.id)
    }
}
