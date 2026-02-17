import Foundation

struct ProfileViewData {
    var name: String
    var description: String
    var websiteTitle: String
    var websiteURL: URL
    var myNftCount: Int
    var favoriteNftCount: Int
    var avatarURLString: String

    var initials: String {
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }
        return String(initials)
    }

    static let mock = ProfileViewData(
        name: "Joaquin Phoenix",
        description: "Дизайнер из Казани, люблю цифровое искусство и бегать. В моей коллекции уже 100+ NFT, и еще больше — на моем сайте. Открыт к коллаборациям.",
        websiteTitle: "Joaquin Phoenix.com",
        websiteURL: URL(string: "https://practicum.yandex.ru/ios-developer/")!,
        myNftCount: 112,
        favoriteNftCount: 11,
        avatarURLString: ""
    )
}
