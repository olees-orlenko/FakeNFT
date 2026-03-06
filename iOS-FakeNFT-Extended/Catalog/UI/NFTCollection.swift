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
