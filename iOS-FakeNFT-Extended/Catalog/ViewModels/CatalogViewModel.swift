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
    
    enum SortOption: Equatable {
        case none
        case byName(ascending: Bool)
        case byCount(ascending: Bool)
    }
    
    enum SortType: Int {
        case none = 0, name = 1, count = 2
    }
    
    // MARK: - Properties
    
    @Published var collections: [NFTCollection] = []
    @Published var isLoading: Bool = false
    @Published private(set) var currentSort: SortOption = .none
    @Published var errorMessage: String? {
        didSet {
            errorAlertPresented = errorMessage != nil
        }
    }
    @Published var errorAlertPresented: Bool = false
    @AppStorage("catalog.sortType") private var storedType: Int = SortType.count.rawValue
    @AppStorage("catalog.sortAscending") private var storedAscending: Bool = false
    private var originalCollections: [NFTCollection] = []
    private let nftService: NFTService
    
    // MARK: - Init
    
    init(nftService: NFTService = NFTService()) {
        self.nftService = nftService
        updateCurrentSortFromStorage()
    }
    
    // MARK: - Loading
    
    func loadCovers() async {
        isLoading = true
        errorMessage = nil
        errorAlertPresented = false
        print("Начата загрузка коллекций")
        defer { isLoading = false }
        do {
            let fetchedCollections = try await nftService.fetchCatalogCollection()
            self.originalCollections = fetchedCollections
            self.collections = fetchedCollections
            applySort(currentSort, isSave: false)
            print("Загрузка коллекций завершена. Количество: \(collections.count)")
        } catch {
            self.errorMessage = (error as? NetworkError)?.localizedDescription ?? error.localizedDescription
            self.errorAlertPresented = true
            self.originalCollections = []
            self.collections = []
            print("Ошибка загрузки коллекций: \(error.localizedDescription)")
        }
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
                let firstCollection = Set($0.nfts).count
                let secondCollection = Set($1.nfts).count
                return ascending ? firstCollection < secondCollection : firstCollection > secondCollection
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
