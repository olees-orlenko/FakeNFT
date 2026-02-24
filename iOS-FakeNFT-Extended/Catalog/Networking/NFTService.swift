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
    
    private let baseURL = RequestConstants.baseURL
    private let token = RequestConstants.token
    private let successStatusCode = 200
    
    // MARK: - Endpoints
    
    private enum Endpoints {
        static let collections = "/api/v1/collections"
        static let nft = "/api/v1/nft"
    }
    
    // MARK: - Fetching Catalog of Collections
    
    func fetchCatalogCollection() async throws -> [NFTCollection] {
        guard let url = URL(string: baseURL + Endpoints.collections) else {
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
            guard httpResponse.statusCode == successStatusCode else {
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
    
    // MARK: - Fetching Collection
    
    func fetchCollection(by id: String) async throws -> NFTCollection {
        guard let url = URL(string: baseURL + Endpoints.collections + "/\(id)") else {
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
            guard httpResponse.statusCode == successStatusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            let decoder = JSONDecoder()
            return try decoder.decode(NFTCollection.self, from: data)
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    // MARK: - Fetching NFT
    
    func fetchNFTs(by ids: [String]) async throws -> [NFTItem] {
        var fetchedItems: [NFTItem] = []
        try await withThrowingTaskGroup(of: NFTItem?.self) { group in
            for id in ids {
                group.addTask {
                    guard let url = URL(string: self.baseURL + Endpoints.nft + "/\(id)") else {
                        throw NetworkError.invalidURL
                    }
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue(self.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
                    request.setValue("application/json", forHTTPHeaderField: "Accept")
                    do {
                        let (data, response) = try await URLSession.shared.data(for: request)
                        guard let httpResponse = response as? HTTPURLResponse else {
                            throw NetworkError.noData
                        }
                        guard httpResponse.statusCode == self.successStatusCode else {
                            throw NetworkError.serverError(httpResponse.statusCode)
                        }
                        let decoder = JSONDecoder()
                        return try decoder.decode(NFTItem.self, from: data)
                    } catch {
                        print("Error fetching NFT with ID \(id): \(error.localizedDescription)")
                        return nil
                    }
                }
            }
            for try await item in group {
                if let item {
                    fetchedItems.append(item)
                }
            }
        }
        return fetchedItems
    }
}
