import Foundation

// MARK: - ProfileUpdateRequest

struct ProfileUpdateRequest: NetworkRequest {
    let dto: Encodable?

    init(dto: ProfileUpdateDTO) {
        self.dto = dto
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        .put
    }
}
