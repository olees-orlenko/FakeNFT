//
//  FavoritesManager.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 20.02.2026.
//

import SwiftUI

final class FavoritesManager: ObservableObject {
    @AppStorage("favoriteNFTs") private var favoriteIDsString: String = ""
    
    func getFavorites() -> Set<String> {
        let ids = favoriteIDsString.split(separator: ",").map(String.init)
        return Set(ids)
    }
    
    func isFavorite(id: String) -> Bool {
        getFavorites().contains(id)
    }
    
    func toggleFavorite(id: String) {
        var favorites = getFavorites()
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        favoriteIDsString = Array(favorites).joined(separator: ",")
        objectWillChange.send()
    }
}
