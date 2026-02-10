//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 09.02.2026.
//

import SwiftUI

// MARK: - ViewModel

@MainActor
final class CatalogViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var collections: [NFTCollection]
    @Published var isLoading: Bool = false

    // MARK: - Init
    
    init(collections: [NFTCollection] = NFTCollection.mockCollections) {
        self.collections = collections
    }

    // MARK: - Loading
    
    func loadCovers() async {
        let urls = collections.compactMap { $0.coverURL }
        guard !urls.isEmpty else { return }
        isLoading = true
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                group.addTask {
                    do {
                        let _ = try await URLSession.shared.data(from: url)
                    } catch {
                    }
                }
            }
            await group.waitForAll()
        }
        try? await Task.sleep(nanoseconds: 80_000_000)
        isLoading = false
    }
}
