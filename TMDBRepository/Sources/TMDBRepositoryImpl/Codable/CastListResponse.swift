import DataModel
import Foundation

/// Represents a person in the cast for a media item (movie or show).
struct CastMemberResponse: Decodable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order
    }
}

/// Represents a person in the crew for a media item (movie or show).
struct CrewMemberResponse: Decodable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let creditID: String
    let department: String
    let job: String

    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case creditID = "credit_id"
        case department
        case job
    }
}

/// Represents a full cast and crew listing for a media item.
struct CastListResponse: Decodable {
    let id: Int
    let cast: [CastMemberResponse]
    let crew: [CrewMemberResponse]
}


extension CastListResponse {
    func toDomainModel() -> CastList {
        CastList(
            id: id,
            cast: cast.map { $0.toDomainModel() },
            crew: crew.map { $0.toDomainModel() }
        )
    }
}

extension CastMemberResponse {
    func toDomainModel() -> CastMember {
        CastMember(
            adult: adult,
            gender: gender,
            id: id,
            knownForDepartment: knownForDepartment,
            name: name,
            originalName: originalName,
            popularity: popularity,
            profilePath: profilePath,
            castID: castID,
            character: character,
            creditID: creditID,
            order: order
        )
    }
}

extension CrewMemberResponse {
    func toDomainModel() -> CrewMember {
        CrewMember(
            adult: adult,
            gender: gender,
            id: id,
            knownForDepartment: knownForDepartment,
            name: name,
            originalName: originalName,
            popularity: popularity,
            profilePath: profilePath,
            creditID: creditID,
            department: CrewMember.Department(rawValue: department) ?? .other,
            job: job
        )
    }
}
