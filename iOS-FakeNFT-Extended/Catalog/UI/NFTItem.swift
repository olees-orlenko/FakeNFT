//
//  NFTItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 16.02.2026.
//

import Foundation

// MARK: - NFTItem

struct NFTItem: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let rating: Int
    let price: String
}

// MARK: - Mocks

extension NFTItem {
    static let mockArchie = NFTItem(name: "Archie", image: "April", rating: 2, price: "1 ETH")
    static let mockRuby = NFTItem(name: "Ruby", image: "April", rating: 3, price: "1 ETH")
    static let mockNacho = NFTItem(name: "Nacho", image: "April", rating: 3, price: "1 ETH")
    static let mockBiscuit = NFTItem(name: "Biscuit", image: "April", rating: 2, price: "1 ETH")
    static let mockDaisy = NFTItem(name: "Daisy", image: "April", rating: 4, price: "1 ETH")
    static let mockSusan = NFTItem(name: "Susan", image: "April", rating: 3, price: "1 ETH")
    static let mockOreo = NFTItem(name: "Oreo", image: "April", rating: 2, price: "1 ETH")
    static let mockPixi = NFTItem(name: "Pixi", image: "April", rating: 3, price: "1 ETH")
    static let mockZoe = NFTItem(name: "Zoe", image: "April", rating: 3, price: "1 ETH")
    static let mockTater = NFTItem(name: "Tater", image: "April", rating: 2, price: "1 ETH")
    
    static let mockItems: [NFTItem] = [
        .mockArchie,
        .mockRuby,
        .mockNacho,
        .mockBiscuit,
        .mockDaisy,
        .mockSusan,
        .mockOreo,
        .mockPixi,
        .mockZoe,
        .mockTater
    ]
}
