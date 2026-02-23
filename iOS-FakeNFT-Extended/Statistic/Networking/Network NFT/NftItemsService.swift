//
//  NftItemsService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 23/02/26.
//

import Foundation

protocol NftItemsService {
    func loadNftItems(ids: [String]) async throws -> [NftItemDTO]
}

actor NftItemsServiceImpl: NftItemsService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func loadNftItems(ids: [String]) async throws -> [NftItemDTO] {
        return try await withThrowingTaskGroup(of: NftItemDTO.self) { group in
            for id in ids {
                group.addTask { [networkClient] in
                    let request = NftItemByIdRequest(id: id)
                    let dto: NftItemDTO = try await networkClient.send(request: request)
                    return dto
                }
            }

            var result: [NftItemDTO] = []
            result.reserveCapacity(ids.count)

            for try await dto in group {
                result.append(dto)
            }
            let order = Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($0.element, $0.offset) })
            return result.sorted { (order[$0.id] ?? 0) < (order[$1.id] ?? 0) }
        }
    }
}
