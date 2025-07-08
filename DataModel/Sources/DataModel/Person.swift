import Foundation

public struct Person: Equatable, Sendable {
    public let adult: Bool
    public let id: Int
    public let name: String
    public let originalName: String?
    public let mediaType: String
    public let popularity: Double
    public let gender: Int?
    public let knownForDepartment: String?
    public let profilePath: String?
    
    public init(
        adult: Bool,
        id: Int,
        name: String,
        originalName: String?,
        mediaType: String,
        popularity: Double,
        gender: Int?,
        knownForDepartment: String?,
        profilePath: String?
    ) {
        self.adult = adult
        self.id = id
        self.name = name
        self.originalName = originalName
        self.mediaType = mediaType
        self.popularity = popularity
        self.gender = gender
        self.knownForDepartment = knownForDepartment
        self.profilePath = profilePath
    }
}

extension Person: Searchable {
    public var title: String {
        name
    }
    
    public var searchItemType: SearchItemType {
        .person
    }
    
    public var subtitle: String {
        knownForDepartment ?? "\(popularity)"
    }
    
    public var posterPath: String? {
        nil
    }
    
    public var backdropPath: String? {
        nil
    }
}
