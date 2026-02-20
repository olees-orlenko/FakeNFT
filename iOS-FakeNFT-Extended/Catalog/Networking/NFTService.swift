//
//  NFTService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 19.02.2026.
//

import Foundation

// MARK: - NFTService

actor NFTService {
    
    // MARK: - Properties
    
    private let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    private let token = "27e1bbac-7be8-4c09-9479-74586f95a085"
    
    // MARK: - Fetching Catalog of Collections
    
    func fetchCatalogCollection() async throws -> [NFTCollection] {
        guard let url = URL(string: "\(baseURL)/api/v1/collections") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            let decoder = JSONDecoder()
            return try decoder.decode([NFTCollection].self, from: data)
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
