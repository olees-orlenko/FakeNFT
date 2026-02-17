import Foundation

struct MyNFTItem: Identifiable {
    let id: String
    let name: String
    let rating: Int
    let author: String
    let price: String

    var priceValue: Double {
        let normalized = price
            .replacingOccurrences(of: "ETH", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: " ", with: "")
        return Double(normalized) ?? 0
    }

    static let mock: [MyNFTItem] = [
        MyNFTItem(id: "1", name: "Lilo", rating: 3, author: "John Doe", price: "1,78 ETH"),
        MyNFTItem(id: "2", name: "Spring", rating: 3, author: "John Doe", price: "1,78 ETH"),
        MyNFTItem(id: "3", name: "April", rating: 3, author: "John Doe", price: "1,78 ETH")
    ]
}
