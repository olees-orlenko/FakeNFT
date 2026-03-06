import Foundation

struct StatisticUserProfileDTO: Decodable, Encodable {
    let id: String
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    var likes: [String]

    init(
        id: String,
        name: String? = nil,
        avatar: String? = nil,
        description: String? = nil,
        website: String? = nil,
        nfts: [String]? = nil,
        likes: [String] = []
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.likes = likes
    }
}
