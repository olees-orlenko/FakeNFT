//
//  UserDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 22/02/26.
//

import Foundation

struct UserDTO: Decodable {

    let id: String?
    let name: String
    let avatar: String?
    let description: String
    let website: String?
    let nfts: [String]
    let rating: Int

    var stableId: String { id ?? name }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatar
        case description
        case website
        case nfts
        case rating
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        self.name = (try? c.decode(String.self, forKey: .name)) ?? "Unknown"

        self.id = try? c.decode(String.self, forKey: .id)
        self.avatar = try? c.decode(String.self, forKey: .avatar)
        self.website = try? c.decode(String.self, forKey: .website)

        self.description = (try? c.decode(String.self, forKey: .description)) ?? ""
        self.nfts = (try? c.decode([String].self, forKey: .nfts)) ?? []

        if let intRating = try? c.decode(Int.self, forKey: .rating) {
            self.rating = intRating
        } else if let strRating = try? c.decode(String.self, forKey: .rating),
                  let intFromStr = Int(strRating.trimmingCharacters(in: .whitespacesAndNewlines)) {
            self.rating = intFromStr
        } else {
            self.rating = 0
        }
    }
}
