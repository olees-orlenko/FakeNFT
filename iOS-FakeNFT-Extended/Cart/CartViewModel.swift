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
    @Published var nfts: [CartModel] = []
    @Published var isLoading = false

    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient()) {
        self.client = client
    }

    func loadCart() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Используем твой новый OrderRequest
            let order: OrderDTO = try await client.send(request: OrderRequest())

            // Загружаем данные для каждого NFT через NFTRequest
            // Используем TaskGroup для параллельной загрузки (чтобы не ждать по очереди)
            nfts = try await withThrowingTaskGroup(of: CartModel?.self) { group in
                for id in order.nfts {
                    group.addTask {
                        let dto: NftDTO = try await self.client.send(request: NFTRequest(id: id))
                        return CartModel(
                            id: dto.id,
                            name: dto.name,
                            image: dto.images.first ?? "",
                            rating: dto.rating,
                            price: dto.price
                        )
                    }
                }

                var loadedNfts: [CartModel] = []
                for try await nft in group {
                    if let nft = nft { loadedNfts.append(nft) }
                }
                return loadedNfts
            }
        } catch {
            print("Ошибка загрузки корзины: \(error)")
        }
    }

    func deleteItem(_ item: CartModel) async {
        // 1. Сначала удаляем из массива локально (для мгновенного UI)
        if let index = nfts.firstIndex(where: { $0.id == item.id }) {
            nfts.remove(at: index)
        }

        // 2. Потом отправляем запрос в сеть
        let updatedIds = nfts.map { $0.id }
        do {
            // Твой UpdateOrderRequest
            let _: OrderDTO = try await client.send(request: UpdateOrderRequest(nfts: updatedIds))
        } catch {
            print("Ошибка при удалении на сервере: \(error)")
            // Если хочешь, тут можно вернуть item обратно в nfts при ошибке
        }
    }
}
