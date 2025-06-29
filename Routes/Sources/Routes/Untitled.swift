public struct MediaSelection<Media: Hashable>: Hashable {
    public let media: Media
    public let key: String
    
    public init(media: Media, key: String) {
        self.media = media
        self.key = key
    }
}
