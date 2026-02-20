//
//  NftViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 17.02.2026.
//

import Foundation

// MARK: - ViewModel

@MainActor
final class NftViewModel: ObservableObject {
    // MARK: - Properties
    
    @Published private(set) var items: [NFTItem] = []
    @Published private(set) var isLoading: Bool = false
    let collection: NFTCollection
    let defaultAuthorURL = URL(string: "https://practicum.yandex.ru/ios-developer/")!

    // MARK: - Init
    
    init(collection: NFTCollection) {
        self.collection = collection
    }

    // MARK: - Loading
    
    func loadItems() async throws {
        isLoading = true
//        defer { isLoading = false }
//        let all = NFTItem.mockItems
//        if collection.itemCount <= 0 {
//            items = all
//        } else {
//            items = Array(all.prefix(collection.itemCount))
//        }
    }

    var authorURL: URL {
        collection.authorURL ?? defaultAuthorURL
    }
}
