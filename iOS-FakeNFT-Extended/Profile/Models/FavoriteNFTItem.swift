import Foundation

struct FavoriteNFTItem: Identifiable {
    let id: String
    let name: String
    let rating: Int
    let price: String

    static let catalog: [FavoriteNFTItem] = [
        FavoriteNFTItem(id: "1", name: "Archie", rating: 1, price: "1,78 ETH"),
        FavoriteNFTItem(id: "2", name: "Pixi", rating: 3, price: "1,78 ETH"),
        FavoriteNFTItem(id: "3", name: "Melissa", rating: 5, price: "1,78 ETH"),
        FavoriteNFTItem(id: "4", name: "April", rating: 2, price: "1,78 ETH"),
        FavoriteNFTItem(id: "5", name: "Daisy", rating: 1, price: "1,78 ETH"),
        FavoriteNFTItem(id: "6", name: "Lilo", rating: 4, price: "1,78 ETH"),
        FavoriteNFTItem(id: "7", name: "Spring", rating: 3, price: "1,78 ETH")
    ]

    static let defaultFavoriteNames = [
        "Archie",
        "Pixi",
        "Melissa",
        "April",
        "Daisy",
        "Lilo"
    ]
}
