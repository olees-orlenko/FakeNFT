import Foundation

// MARK: - ProfileUpdateDTO

/// DTO для обновления профиля пользователя.
/// Используется в PATCH/PUT запросах.
struct ProfileUpdateDTO: Encodable {
    /// Новое имя пользователя.
    let name: String

    /// Новое описание профиля.
    let description: String

    /// Новый URL аватара.
    let avatar: String

    /// Новый сайт пользователя.
    let website: String

    /// Обновлённый список id избранных NFT.
    let likes: [String]
}
