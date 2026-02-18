//
//  NFTCollection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 05.02.2026.
//

import SwiftUI

// MARK: - NFTCollection

struct NFTCollection: Identifiable {
    let id: UUID = UUID()
    let title: String
    let coverURL: URL?
    let itemCount: Int
    let authorName: String?
    let authorURL: URL?
    let description: String?
}

// MARK: - Mocks

extension NFTCollection {
    static var mockCollections: [NFTCollection] {
        [
            NFTCollection(
                title: "Peach",
                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                itemCount: 11,
                authorName: "John Doe",
                authorURL: URL(string: "https://example.com"),
                description: """
                Персиковый — как облака над закатным солнцем в океане. \
                В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.
                """
            ),
            NFTCollection(
                title: "Blue",
                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/White.png"),
                itemCount: 6,
                authorName: "John Doe",
                authorURL: URL(string: "https://example.com"),
                description: """
                Персиковый — как облака над закатным солнцем в океане. \
                В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.
                """
            ),
            NFTCollection(
                title: "Red",
                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
                itemCount: 9,
                authorName: "John Doe",
                authorURL: URL(string: "https://example.com"),
                description: """
                Персиковый — как облака над закатным солнцем в океане. \
                В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.
                """
            ),
            NFTCollection(
                title: "Brown",
                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
                itemCount: 8,
                authorName: "John Doe",
                authorURL: URL(string: "https://example.com"),
                description: """
                Персиковый — как облака над закатным солнцем в океане. \
                В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.
                """
            )
        ]
    }
}
