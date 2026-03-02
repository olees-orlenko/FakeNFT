//
//  FavoritesManager.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 20.02.2026.
//

import SwiftUI

final class FavoritesManager: ObservableObject {
    @AppStorage("favoriteNFTs") private var favoriteIDsString: String = ""
    @AppStorage("favoriteNFTsHasLocalOverride") private var hasLocalOverride: Bool = false
    @Published private(set) var favoriteIDs: Set<String> = []

    init() {
        let ids = favoriteIDsString.isEmpty ? [] : favoriteIDsString.split(separator: ",").map(String.init)
        favoriteIDs = Set(ids)
    }

    private func persist(markLocalOverride: Bool = true) {
        favoriteIDsString = favoriteIDs.sorted().joined(separator: ",")
        if markLocalOverride {
            hasLocalOverride = true
        }
    }
    
    func getFavorites() -> Set<String> {
        favoriteIDs
    }

    func replace(with ids: Set<String>) {
        favoriteIDs = ids
        persist()
    }

    func replaceFromServer(with ids: Set<String>) {
        guard !hasLocalOverride else { return }
        favoriteIDs = ids
        persist(markLocalOverride: false)
    }

    func insert(id: String) {
        favoriteIDs.insert(id)
        persist()
    }

    func remove(id: String) {
        favoriteIDs.remove(id)
        persist()
    }
    
    func isFavorite(id: String) -> Bool {
        favoriteIDs.contains(id)
    }
    
    func toggleFavorite(id: String) {
        if favoriteIDs.contains(id) {
            self.remove(id: id)
        } else {
            self.insert(id: id)
        }
    }
}
