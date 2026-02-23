import Foundation

struct OrderDTO: Codable {
    let nfts: [String]
    let id: String
}

struct NftDTO: Codable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}

struct CurrencyDTO: Codable, Identifiable {
    let id: String
    let title: String
    let name: String
    let image: String
}

struct OrderPaymentResult: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
