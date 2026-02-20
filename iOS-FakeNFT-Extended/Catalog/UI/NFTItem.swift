//
//  NFTItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 16.02.2026.
//

import Foundation

// MARK: - NFTItem

struct NFTItem: Identifiable, Codable, Sendable {
    let id: String
    let name: String
    let rating: Int
    let price: Double
    let description: String?
    let author: String
    let website: String?
    let createdAt: String
    private let images: [String]
    var priceString: String {
        String(format: "%.2f ETH", price)
    }
    var image: URL? {
        images.first.flatMap(URL.init)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case rating
        case price
        case description
        case author
        case website
        case createdAt
        case images
    }
    
    init(id: String = UUID().uuidString,
         name: String,
         imageURLString: String? = nil,
         rating: Int,
         price: Double,
         description: String? = nil,
         author: String = "",
         website: String? = nil,
         createdAt: String = "") {
        self.id = id
        self.name = name
        self.rating = rating
        self.price = price
        self.description = description
        self.author = author
        self.website = website
        self.createdAt = createdAt
        self.images = imageURLString.map { [$0] } ?? []
    }
}

// MARK: - Mocks

//extension NFTItem {
//    static let mockArchie = NFTItem(name: "Archie", image: "April", rating: 2, price: "1 ETH")
//    static let mockRuby = NFTItem(name: "Ruby", image: "April", rating: 3, price: "1 ETH")
//    static let mockNacho = NFTItem(name: "Nacho", image: "April", rating: 3, price: "1 ETH")
//    static let mockBiscuit = NFTItem(name: "Biscuit", image: "April", rating: 2, price: "1 ETH")
//    static let mockDaisy = NFTItem(name: "Daisy", image: "April", rating: 4, price: "1 ETH")
//    static let mockSusan = NFTItem(name: "Susan", image: "April", rating: 3, price: "1 ETH")
//    static let mockOreo = NFTItem(name: "Oreo", image: "April", rating: 2, price: "1 ETH")
//    static let mockPixi = NFTItem(name: "Pixi", image: "April", rating: 3, price: "1 ETH")
//    static let mockZoe = NFTItem(name: "Zoe", image: "April", rating: 3, price: "1 ETH")
//    static let mockTater = NFTItem(name: "Tater", image: "April", rating: 2, price: "1 ETH")
//    
//    static let mockItems: [NFTItem] = [
//        .mockArchie,
//        .mockRuby,
//        .mockNacho,
//        .mockBiscuit,
//        .mockDaisy,
//        .mockSusan,
//        .mockOreo,
//        .mockPixi,
//        .mockZoe,
//        .mockTater
//    ]
//}
