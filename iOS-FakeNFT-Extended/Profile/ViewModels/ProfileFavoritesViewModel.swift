import Foundation

// MARK: - ProfileFavoritesViewModel

final class ProfileFavoritesViewModel: ObservableObject {
    @Published private(set) var favoriteIDs: Set<String>

    init(initialFavoriteIDs: Set<String> = []) {
        self.favoriteIDs = initialFavoriteIDs
    }

    func replace(with ids: Set<String>) {
        favoriteIDs = ids
    }

    func insert(id: String) {
        favoriteIDs.insert(id)
    }

    func remove(id: String) {
        favoriteIDs.remove(id)
    }

    func isFavorite(id: String) -> Bool {
        favoriteIDs.contains(id)
    }
}
