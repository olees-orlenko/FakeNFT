import Foundation

// MARK: - ProfileService

protocol ProfileService {
    func fetchProfile() async throws -> ProfileDTO
    func fetchNFTList() async throws -> [Nft]
    func updateProfile(_ dto: ProfileUpdateDTO) async throws -> ProfileDTO
}

// MARK: - ProfileServiceImpl

@MainActor
final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchProfile() async throws -> ProfileDTO {
        let request = ProfileRequest()
        return try await networkClient.send(request: request)
    }

    func fetchNFTList() async throws -> [Nft] {
        let request = NFTListRequest()
        return try await networkClient.send(request: request)
    }

    func updateProfile(_ dto: ProfileUpdateDTO) async throws -> ProfileDTO {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1") else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.put.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        request.httpBody = makeFormBody(from: dto).data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw NetworkClientError.urlSessionError
        }
        guard 200 ..< 300 ~= http.statusCode else {
            throw NetworkClientError.httpStatusCode(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(ProfileDTO.self, from: data)
        } catch {
            throw NetworkClientError.parsingError
        }
    }

    private func makeFormBody(from dto: ProfileUpdateDTO) -> String {
        let fields: [(String, String)] = [
            ("name", dto.name),
            ("description", dto.description),
            ("avatar", dto.avatar),
            ("website", dto.website)
        ]

        var parts = fields.map { key, value in
            "\(escape(key))=\(escape(value))"
        }
        if dto.likes.isEmpty {
            parts.append("likes=")
            parts.append("likes[]=")
        } else {
            parts.append(contentsOf: dto.likes.map { "likes=\(escape($0))" })
        }

        return parts.joined(separator: "&")
    }

    private func escape(_ value: String) -> String {
        value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
            .replacingOccurrences(of: "+", with: "%2B")
            .replacingOccurrences(of: "&", with: "%26")
            .replacingOccurrences(of: "=", with: "%3D") ?? value
    }
}
