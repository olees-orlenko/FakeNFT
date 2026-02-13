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
    
    // MARK: - Sort options
    
    enum SortOption {
        case none
        case byName(ascending: Bool)
        case byCount(ascending: Bool)
    }
    
    enum SortType: Int {
        case none = 0, name = 1, count = 2
    }
    
    // MARK: - Properties
    
    @Published var collections: [NFTCollection]
    @Published var isLoading: Bool = false
    @Published private(set) var currentSort: SortOption = .none
    @AppStorage("catalog.sortType") private var storedType: Int = SortType.count.rawValue
    @AppStorage("catalog.sortAscending") private var storedAscending: Bool = false
    private var originalCollections: [NFTCollection]
    
    // MARK: - Init
    
    init(collections: [NFTCollection] = NFTCollection.mockCollections) {
        self.originalCollections = collections
        self.collections = collections
        updateCurrentSortFromStorage()
    }
    
    // MARK: - Loading
    
    func loadCovers() async {
        let urls = collections.compactMap { $0.coverURL }
        guard !urls.isEmpty else { return }
        isLoading = true
        print("Начата загрузка обложек")
        defer { isLoading = false }
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
        isLoading = false
        print("Загрузка обложек завершена")
    }
    
    // MARK: - Filtering
    
    func sort(by option: SortOption) {
        applySort(option, isSave: true)
    }
    
    private func applySort(_ option: SortOption, isSave: Bool) {
        currentSort = option
        switch option {
        case .none:
            collections = originalCollections
        case .byName(let ascending):
            collections = originalCollections.sorted {
                ascending
                ? $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
                : $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending
            }
        case .byCount(let ascending):
            collections = originalCollections.sorted {
                ascending ? $0.itemCount < $1.itemCount : $0.itemCount > $1.itemCount
            }
        }
        if isSave {
            switch option {
            case .none:
                storedType = SortType.none.rawValue
                storedAscending = true
            case .byName(let ascending):
                storedType = SortType.name.rawValue
                storedAscending = ascending
            case .byCount(let ascending):
                storedType = SortType.count.rawValue
                storedAscending = ascending
            }
        }
    }
    
    func updateCurrentSortFromStorage() {
        let type = SortType(rawValue: storedType) ?? .none
        switch type {
        case .none:
            applySort(.none, isSave: false)
        case .name:
            applySort(.byName(ascending: storedAscending), isSave: false)
        case .count:
            applySort(.byCount(ascending: storedAscending), isSave: false)
        }
    }
}
