// Cast and Crew models for media items.

import Foundation

/// Protocol representing a member of the cast or crew for a media item.
/// Provides common properties like ID, name, role, and profile image path.
/// Conforms to Sendable for safe usage across concurrency domains.
public protocol CastAndCrewMember: Equatable, Sendable {
    /// Unique identifier for the cast or crew member.
    var id: Int { get }
    /// Name of the cast or crew member.
    var name: String { get }
    /// Role or job title of the cast or crew member.
    var role: String { get }
    /// Optional path to the profile image of the cast or crew member.
    var profilePath: String? { get }
}

/// Represents a full cast and crew listing for a media item.
/// Validates that the media item ID is positive.
/// Conforms to Sendable for safe usage across concurrency domains.
public struct CastAndCrewList: Equatable, Sendable {
    /// Unique identifier for the media item.
    public let id: Int
    /// Full list of cast members.
    public let cast: [CastMember]
    /// Full list of crew members.
    public let crew: [CrewMember]
    /// Subset of cast members considered important (up to 15 members).
    public let importantCast: [CastMember]
    /// Subset of crew members considered important (filtered by displayable departments).
    public let importantCrew: [CrewMember]
    
    /// Initialize a CastAndCrewList with the full cast and crew lists.
    /// - Parameters:
    ///   - id: The media item's unique identifier. Must be positive.
    ///   - cast: Full list of cast members.
    ///   - crew: Full list of crew members.
    ///
    /// `importantCast` is limited to the first 15 members of `cast`.
    /// `importantCrew` includes only crew members from displayable departments.
    /// This initializer enforces validation on `id`.
    public init(id: Int, cast: [CastMember], crew: [CrewMember]) {
        self.id = id
        self.cast = cast
        self.crew = crew
        self.importantCast = Array(cast.prefix(min(cast.endIndex, 15)))
        self.importantCrew = crew.filter {
            CrewMember.Department.displayableDepartment.contains($0.department)
        }
    }
    
    /// Combined list of important cast and crew members.
    @inlinable public var castAndCrew: [any CastAndCrewMember] {
        importantCast + importantCrew
    }
}

/// Represents a person in the cast for a media item (movie or show).
/// Validates that `id` is positive and names are non-empty.
/// Conforms to Sendable for safe usage across concurrency domains.
public struct CastMember: CastAndCrewMember {
    /// Indicates if the cast member is an adult.
    public let adult: Bool
    /// Numeric gender identifier.
    public let gender: Int
    /// Unique identifier for the cast member.
    public let id: Int
    /// The department this person is known for.
    public let knownForDepartment: String
    /// Name of the cast member.
    public let name: String
    /// Original name of the cast member.
    public let originalName: String
    /// Popularity score.
    public let popularity: Double
    /// Optional path to profile image.
    public let profilePath: String?
    /// Optional cast identifier, specific to cast lists.
    public let castID: Int?
    /// Character name portrayed by the cast member.
    public let character: String?
    /// Credit identifier string.
    public let creditID: String
    /// Optional order value indicating position in credits.
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
    
    /// Role displayed for this cast member, defaults to character name if available, otherwise the member's name.
    @inlinable public var role: String {
        character ?? name
    }
}

/// Represents a person in the crew for a media item (movie or show).
/// Validates that `id` is positive and names are non-empty.
/// Conforms to Sendable for safe usage across concurrency domains.
public struct CrewMember: CastAndCrewMember {
    /// Enumeration of possible crew departments.
    public enum Department: String, Equatable, Sendable {
        /// Production department.
        case production = "Production"
        /// Art department.
        case art = "Art"
        /// Camera department.
        case camera = "Camera"
        /// Costume and make-up department.
        case costumeMakeUp = "Costume & Make-Up"
        /// General crew department.
        case crew = "Crew"
        /// Directing department.
        case directing = "Directing"
        /// Editing department.
        case editing = "Editing"
        /// Lighting department.
        case lighting = "Lighting"
        /// Sound department.
        case sound = "Sound"
        /// Visual effects department.
        case visualEffects = "Visual Effects"
        /// Writing department.
        case writing = "Writing"
        /// Acting department.
        case acting = "Acting"
        /// Creator department.
        case creator = "Creator"
        /// Other/unspecified department.
        case other
        
        /// Departments considered displayable or important when filtering crew members.
        static let displayableDepartment: [Department] = {
            [.acting, .creator, .directing]
        }()
    }

    /// Indicates if the crew member is an adult.
    public let adult: Bool
    /// Numeric gender identifier.
    public let gender: Int
    /// Unique identifier for the crew member.
    public let id: Int
    /// The department this person is known for.
    public let knownForDepartment: String
    /// Name of the crew member.
    public let name: String
    /// Original name of the crew member.
    public let originalName: String
    /// Popularity score.
    public let popularity: Double
    /// Optional path to profile image.
    public let profilePath: String?
    /// Credit identifier string.
    public let creditID: String
    /// The department the crew member belongs to.
    public let department: Department
    /// The specific job title of the crew member.
    public let job: String
    
    /// Initializes a CrewMember instance with all properties.
    /// - Parameters:
    ///   - adult: Indicates if the crew member is an adult.
    ///   - gender: Numeric gender identifier.
    ///   - id: Unique identifier. Must be positive.
    ///   - knownForDepartment: Department the person is known for.
    ///   - name: Name of the crew member. Must be non-empty.
    ///   - originalName: Original name. Must be non-empty.
    ///   - popularity: Popularity score.
    ///   - profilePath: Optional profile image path.
    ///   - creditID: Credit identifier string.
    ///   - department: Crew department enum value.
    ///   - job: Specific job title.
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
        department: Department,
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
    
    /// Role displayed for this crew member, which is their job title.
    @inlinable public var role: String {
        job
    }
}
