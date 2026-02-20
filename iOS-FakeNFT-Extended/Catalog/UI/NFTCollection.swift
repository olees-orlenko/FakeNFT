//
//  NFTCollection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 05.02.2026.
//

import SwiftUI

// MARK: - NFTCollection

struct NFTCollection: Identifiable, Codable, Sendable {
    let id: String
    let title: String
    let coverURL: URL?
    let authorName: String?
    let authorURL: URL?
    let description: String?
    let createdAt: String
    let nfts: [String]
    var itemCount: Int { nfts.count }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case coverURL = "cover"
        case nfts
        case authorName = "author"
        case authorURL = "website"
        case description
        case createdAt
    }
    
    // MARK: - Init
    
    init(
        id: String = UUID().uuidString,
        title: String,
        coverURL: String? = nil,
        nfts: [String] = [],
        authorName: String? = nil,
        authorURL: String? = nil,
        description: String? = nil,
        createdAt: String = ""
    ) {
        self.id = id
        self.title = title
        self.coverURL = URL(string: coverURL ?? "")
        self.nfts = nfts
        self.authorName = authorName
        self.authorURL = URL(string: authorURL ?? "")
        self.description = description
        self.createdAt = createdAt
    }
}

// MARK: - Mocks

//extension NFTCollection {
//    static var mockCollections: [NFTCollection] {
//        [
//            NFTCollection(
//                title: "Peach",
//                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
//                itemCount: 11,
//                authorName: "John Doe",
//                authorURL: URL(string: "https://practicum.yandex.ru/ios-developer/"),
//                description: """
//                Персиковый — как облака над закатным солнцем в океане. \
//                В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.
//                """
//            ),
//            NFTCollection(
//                title: "Blue",
//                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/White.png"),
//                itemCount: 6,
//                authorName: "John Doe",
//                authorURL: URL(string: "https://example.com"),
//                description: """
//                Персиковый — как облака над закатным солнцем в океане. \
//                В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.
//                """
//            ),
//            NFTCollection(
//                title: "Red",
//                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
//                itemCount: 9,
//                authorName: "John Doe",
//                authorURL: URL(string: "https://example.com"),
//                description: """
//                Персиковый — как облака над закатным солнцем в океане. \
//                В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.
//                """
//            ),
//            NFTCollection(
//                title: "Brown",
//                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
//                itemCount: 8,
//                authorName: "John Doe",
//                authorURL: URL(string: "https://example.com"),
//                description: """
//                Персиковый — как облака над закатным солнцем в океане. \
//                В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.
//                """
//            )
//        ]
//    }
//}
