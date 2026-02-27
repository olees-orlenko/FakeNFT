//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 15.02.26.
//


import Foundation

struct OrderDTO: Codable {
    let nfts: [String]
    let id: String
}

struct NFTCartItem: Codable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}

enum NetworkCartError: Error, LocalizedError {
    case invalidURL
    case noData
    case serverError(Int)
    case decodingError(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Неверный URL-адрес."
        case .noData: return "Нет данных от сервера."
        case let .serverError(statusCode): return "Ошибка сервера: код \(statusCode)."
        case let .decodingError(error): return "Ошибка декодирования: \(error.localizedDescription)"
        case let .unknown(error): return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}

// MARK: - Cart Service

actor CartService {
    private let baseURL = RequestConstants.baseURL
    private let token = RequestConstants.token

    func fetchOrder() async throws -> OrderDTO {
        try await performRequest(path: "/api/v1/orders/1")
    }

    func fetchNFTs(by ids: [String]) async throws -> [NFTCartItem] {
        var fetchedItems: [NFTCartItem] = []
        try await withThrowingTaskGroup(of: NFTCartItem?.self) { group in
            for id in ids {
                group.addTask {
                    try? await self.performRequest(path: "/api/v1/nft/\(id)")
                }
            }
            for try await item in group {
                if let item = item { fetchedItems.append(item) }
            }
        }
        return fetchedItems
    }

    func updateOrder(nftIds: [String]) async throws -> OrderDTO {
        guard let url = URL(string: "\(baseURL)/api/v1/orders/1") else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let bodyString = nftIds.map { "nfts=\($0)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkCartError.noData }


        if httpResponse.statusCode != 200 {
            if let serverError = String(data: data, encoding: .utf8) {
                print("DEBUG: Ошибка сервера (тело): \(serverError)")
            }
            throw NetworkCartError.serverError(httpResponse.statusCode)
        }

        return try JSONDecoder().decode(OrderDTO.self, from: data)
    }

     func performRequest<T: Decodable>(path: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(path)") else { throw NetworkCartError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkCartError.noData }
        guard httpResponse.statusCode == 200 else { throw NetworkCartError.serverError(httpResponse.statusCode) }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkCartError.decodingError(error)
        }
    }
}
