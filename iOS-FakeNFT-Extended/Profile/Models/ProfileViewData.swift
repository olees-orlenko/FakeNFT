import Foundation

struct ProfileViewData {
    let name: String
    let description: String
    let websiteTitle: String
    let websiteURL: URL
    let myNftCount: Int
    let favoriteNftCount: Int
    let avatarURLString: String

    var initials: String {
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }
        return String(initials)
    }

    func updated(
        name: String,
        description: String,
        websiteTitle: String,
        websiteURL: URL,
        avatarURLString: String,
        myNftCount: Int,
        favoriteNftCount: Int
    ) -> ProfileViewData {
        ProfileViewData(
            name: name,
            description: description,
            websiteTitle: websiteTitle,
            websiteURL: websiteURL,
            myNftCount: myNftCount,
            favoriteNftCount: favoriteNftCount,
            avatarURLString: avatarURLString
        )
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
