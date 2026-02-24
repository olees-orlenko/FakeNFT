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

    func loadCart() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let order: OrderDTO = try await service.fetchOrder()

            guard !order.nfts.isEmpty else {
                await MainActor.run { self.nfts = [] }
                return
            }

            let nftDetails = try await service.fetchNFTs(by: order.nfts)

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
        try? await service.updateOrder(nftIds: nfts.map { $0.id })
    }
}
