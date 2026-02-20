import Foundation

// MARK: - ProfileDTO

/// DTO профиля пользователя, получаемый из API.
/// Используется для отображения экрана профиля и связанных списков.
struct ProfileDTO: Codable {
    /// Имя пользователя.
    let name: String

    /// URL-строка аватара пользователя.
    let avatar: String

    /// Описание профиля.
    let description: String

    /// Ссылка на сайт пользователя.
    let website: String

    /// Список идентификаторов NFT пользователя.
    let nfts: [String]

    /// Список идентификаторов избранных NFT.
    let likes: [String]

    /// Уникальный идентификатор пользователя.
    let id: String
}
