// This file defines the CastList and supporting types for movie/TV cast and crew responses in TMDB-style JSON.

import Foundation

/// Represents a full cast and crew listing for a media item.
public struct CastList: Equatable, Sendable {
    public let id: Int
    public let cast: [CastMember]
    public let crew: [CrewMember]
    
    public init(id: Int, cast: [CastMember], crew: [CrewMember]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }
}

/// Represents a person in the cast for a media item (movie or show).
public struct CastMember: Equatable, Sendable {
    public let adult: Bool
    public let gender: Int
    public let id: Int
    public let knownForDepartment: String
    public let name: String
    public let originalName: String
    public let popularity: Double
    public let profilePath: String?
    public let castID: Int?
    public let character: String?
    public let creditID: String
    public let order: Int?
    
    public init(
        adult: Bool,
        gender: Int,
        id: Int,
        knownForDepartment: String,
        name: String,
        originalName: String,
        popularity: Double,
        profilePath: String?,
        castID: Int?,
        character: String?,
        creditID: String,
        order: Int?
    ) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.castID = castID
        self.character = character
        self.creditID = creditID
        self.order = order
    }
}

/// Represents a person in the crew for a media item (movie or show).
public struct CrewMember: Equatable, Sendable {
    public let adult: Bool
    public let gender: Int
    public let id: Int
    public let knownForDepartment: String
    public let name: String
    public let originalName: String
    public let popularity: Double
    public let profilePath: String?
    public let creditID: String
    public let department: String
    public let job: String
    
    public init(
        adult: Bool,
        gender: Int,
        id: Int,
        knownForDepartment: String,
        name: String,
        originalName: String,
        popularity: Double,
        profilePath: String?,
        creditID: String,
        department: String,
        job: String
    ) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.creditID = creditID
        self.department = department
        self.job = job
    }
    
}
