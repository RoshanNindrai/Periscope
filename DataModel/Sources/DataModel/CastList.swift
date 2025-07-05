import Foundation

public protocol CastAndCrewMember: Equatable, Sendable {
    var id: Int { get }
    var name: String { get }
    var role: String { get }
    var profilePath: String? { get }
}

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
    
    public var castAndCrew: [any CastAndCrewMember] {
        importantCast + importantCrew
    }
    
    private var importantCast: [CastMember] {
        Array(cast.prefix(min(cast.endIndex, 15)))
    }
    
    private var importantCrew: [CrewMember] {
        crew.filter { CrewMember.Department.displayableDepartment.contains($0.department) }
    }
}

/// Represents a person in the cast for a media item (movie or show).
public struct CastMember: CastAndCrewMember {
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
    
    public var role: String {
        character ?? name
    }
}

/// Represents a person in the crew for a media item (movie or show).
public struct CrewMember: CastAndCrewMember {

    public enum Department: String, Equatable, Sendable {
        case production = "Production"
        case art = "Art"
        case camera = "Camera"
        case costumeMakeUp = "Costume & Make-Up"
        case crew = "Crew"
        case directing = "Directing"
        case editing = "Editing"
        case lighting = "Lighting"
        case sound = "Sound"
        case visualEffects = "Visual Effects"
        case writing = "Writing"
        case acting = "Acting"
        case creator = "Creator"
        case other
        
        static let displayableDepartment: [Department] = {
            [.acting, .creator, .directing]
        }()
    }

    public let adult: Bool
    public let gender: Int
    public let id: Int
    public let knownForDepartment: String
    public let name: String
    public let originalName: String
    public let popularity: Double
    public let profilePath: String?
    public let creditID: String
    /// The department the crew member belongs to, represented as a CrewDepartment enum.
    public let department: Department
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
    
    public var role: String {
        job
    }
}

