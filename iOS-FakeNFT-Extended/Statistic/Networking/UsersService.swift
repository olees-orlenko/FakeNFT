//
//  UsersService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 22/02/26.
//

import Foundation

protocol UsersService {
    func loadUsers(page: Int, size: Int, sortBy: String?) async throws -> [UserDTO]
    func loadUser(id: String) async throws -> UserDTO
}

actor UsersServiceImpl: UsersService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func loadUsers(page: Int, size: Int, sortBy: String?) async throws -> [UserDTO] {
        let request = UsersRequest(page: page, size: size, sortBy: sortBy)
        return try await networkClient.send(request: request)
    }

    func loadUser(id: String) async throws -> UserDTO {
        let request = UserByIdRequest(id: id)
        return try await networkClient.send(request: request)
    }
}
