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
}

// MARK: - Mocks

extension NFTCollection {
    static var mockCollections: [NFTCollection] {
        [
            NFTCollection(
                title: "Peach",
                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                itemCount: 11
            ),
            NFTCollection(
                title: "Blue",
                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/White.png"),
                itemCount: 6
            ),
            NFTCollection(
                title: "Red",
                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
                itemCount: 9
            ),
            NFTCollection(
                title: "Brown",
                coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
                itemCount: 8
            )
        ]
    }
}
