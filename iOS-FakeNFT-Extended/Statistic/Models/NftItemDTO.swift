//
//  NftItemDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 23/02/26.
//

import Foundation

struct NftItemDTO: Decodable {
    let createdAt: String?
    let name: String
    let images: [URL]
    let rating: Int
    let description: String?
    let price: Double
    let author: String?
    let website: String?
    let id: String
}
