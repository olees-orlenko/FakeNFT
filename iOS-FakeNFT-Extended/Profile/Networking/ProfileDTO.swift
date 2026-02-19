import Foundation

// MARK: - ProfileDTO

struct ProfileDTO: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

// MARK: - ProfileUpdateDTO

struct ProfileUpdateDTO: Encodable {
    let name: String
    let description: String
    let avatar: String
    let website: String
    let likes: [String]
}
