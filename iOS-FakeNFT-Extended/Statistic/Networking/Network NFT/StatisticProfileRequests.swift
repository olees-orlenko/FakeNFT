import Foundation

struct StatisticProfileRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
}

struct StatisticUpdateProfileRequest: NetworkRequest {
    let id: String
    let profile: StatisticUserProfileDTO

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod { .put }
    var dto: Encodable? { profile }
}
