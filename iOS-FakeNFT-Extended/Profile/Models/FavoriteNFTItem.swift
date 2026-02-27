import Foundation

struct FavoriteNFTItem: Identifiable {
    let id: String
    let name: String
    let rating: Int
    let price: String
    let imageURL: URL?

    init(
        id: String,
        name: String,
        rating: Int,
        price: String,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.rating = rating
        self.price = price
        self.imageURL = imageURL
    }

    init(nft: Nft) {
        self.id = nft.id
        self.name = nft.name
        self.rating = nft.rating
        self.price = Self.formattedPrice(from: nft.price)
        self.imageURL = nft.images.first
    }

    static let catalog: [FavoriteNFTItem] = [
        FavoriteNFTItem(id: "1", name: "Archie", rating: 1, price: "1,78 ETH"),
        FavoriteNFTItem(id: "2", name: "Pixi", rating: 3, price: "1,78 ETH"),
        FavoriteNFTItem(id: "3", name: "Melissa", rating: 5, price: "1,78 ETH"),
        FavoriteNFTItem(id: "4", name: "April", rating: 2, price: "1,78 ETH"),
        FavoriteNFTItem(id: "5", name: "Daisy", rating: 1, price: "1,78 ETH"),
        FavoriteNFTItem(id: "6", name: "Lilo", rating: 4, price: "1,78 ETH"),
        FavoriteNFTItem(id: "7", name: "Spring", rating: 3, price: "1,78 ETH")
    ]

    private static func formattedPrice(from value: Double) -> String {
        String(format: "%.2f ETH", value).replacingOccurrences(of: ".", with: ",")
    }
}
