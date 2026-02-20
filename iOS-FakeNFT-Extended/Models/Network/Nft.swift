import Foundation

/// Модель NFT, получаемая из API.
/// Используется на экранах профиля, каталога и карточки NFT.
struct Nft: Decodable {
    /// Дата создания NFT в формате ISO8601.
    let createdAt: String

    /// Название токена.
    let name: String

    /// Уникальный идентификатор NFT.
    let id: String

    /// Массив ссылок на изображения токена.
    let images: [URL]

    /// Рейтинг токена в диапазоне 0...5.
    let rating: Int

    /// Текстовое описание NFT.
    let description: String

    /// Стоимость токена.
    let price: Double

    /// Идентификатор автора NFT.
    let author: String

    /// Ссылка на сайт проекта или автора.
    let website: String
}
