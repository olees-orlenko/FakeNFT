import Foundation

struct MyNFTItem: Identifiable {
    let id: String
    let name: String
    let rating: Int
    let author: String
    let price: String
    let imageURL: URL?

    init(
        id: String,
        name: String,
        rating: Int,
        author: String,
        price: String,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.rating = rating
        self.author = author
        self.price = price
        self.imageURL = imageURL
    }

    init(nft: Nft) {
        self.id = nft.id
        self.name = nft.name
        self.rating = nft.rating
        self.author = nft.author
        self.price = Self.formattedPrice(from: nft.price)
        self.imageURL = nft.images.first
    }

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

    private static func formattedPrice(from value: Double) -> String {
        String(format: "%.2f ETH", value).replacingOccurrences(of: ".", with: ",")
    }
}
