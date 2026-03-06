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
    @Published private(set) var collection: NFTCollection
    @Published var errorMessage: String? {
        didSet {
            errorAlertPresented = errorMessage != nil
        }
    }
    @Published var errorAlertPresented: Bool = false
    private let defaultAuthorURL = URL(string: "https://practicum.yandex.ru/ios-developer/")!
    private let nftService: NFTService
    
    // MARK: - Init
    
    init(collection: NFTCollection, nftService: NFTService = NFTService()) {
        self.collection = collection
        self.nftService = nftService
    }
    
    // MARK: - Fetching Collection
    
    func fetchCollection() async {
        isLoading = true
        errorMessage = nil
        errorAlertPresented = false
        defer { isLoading = false }
        do {
            let updated = try await nftService.fetchCollection(by: collection.id)
            self.collection = updated
        } catch {
            self.errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
            self.items = []
            self.collection = NFTCollection(
                id: self.collection.id,
                title: self.collection.title,
                coverURL: self.collection.coverURL?.absoluteString,
                nfts: [],
                authorName: self.collection.authorName,
                authorURL: self.collection.authorURL?.absoluteString,
                description: self.collection.description,
                createdAt: self.collection.createdAt
            )
            print("Ошибка загрузки всех данных для коллекции: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Loading
    
    func loadItems() async {
        guard !collection.nfts.isEmpty else {
            self.items = []
            return
        }
        isLoading = true
        errorMessage = nil
        errorAlertPresented = false
        defer { isLoading = false }
        do {
            let fetched = try await nftService.fetchNFTs(by: collection.nfts)
            let nftMap = Dictionary(fetched.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
            var uniqueIds = Set<String>()
            self.items = collection.nfts.compactMap { id in
                guard !uniqueIds.contains(id) else { return nil }
                uniqueIds.insert(id)
                return nftMap[id]
            }
        } catch {
            self.items = []
            self.errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
            self.errorAlertPresented = true
        }
    }
    
    var authorURL: URL {
        defaultAuthorURL
    }
}
