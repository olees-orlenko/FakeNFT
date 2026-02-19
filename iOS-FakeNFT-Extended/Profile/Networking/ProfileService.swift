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
        let request = ProfileUpdateRequest(dto: dto)
        return try await networkClient.send(request: request)
    }
}
