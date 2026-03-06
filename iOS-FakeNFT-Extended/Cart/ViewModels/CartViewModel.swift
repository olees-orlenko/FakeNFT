//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 23.02.26.
//
import Foundation
import SwiftUI

@MainActor
final class CartViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var nfts: [CartModel] = []
    @Published var isLoading = false

    private let service = CartService()
    private let cartStorageKey = "cartNFTs"

    func loadCart() async {
        isLoading = true
        defer { isLoading = false }

        let ids = currentCartIDs()
        guard !ids.isEmpty else {
            nfts = []
            return
        }

        do {
            let nftDetails = try await service.fetchNFTs(by: ids)

            await MainActor.run {
                self.nfts = nftDetails.map { nft in
                    CartModel(
                        id: nft.id,
                        name: nft.name,
                        image: nft.images.first ?? "",
                        rating: nft.rating,
                        price: nft.price
                    )
                }
            }
        } catch {
            print("❌ Ошибка загрузки корзины: \(error)")
        }
    }

    func deleteItem(_ item: CartModel) async {
        nfts.removeAll { $0.id == item.id }
        let ids = nfts.map { $0.id }
        if ids.isEmpty {
            _ = try? await service.clearOrder()
        } else {
            _ = try? await service.updateOrder(nftIds: ids)
        }
    }

    private func currentCartIDs() -> [String] {
        let value = UserDefaults.standard.string(forKey: cartStorageKey) ?? ""
        if value.isEmpty { return [] }
        return value.split(separator: ",").map(String.init)
    }
}
