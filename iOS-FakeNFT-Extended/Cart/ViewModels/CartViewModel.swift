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
    
    private let cartService = CartService()

    func loadCart() async {
        isLoading = true
        defer { isLoading = false }
        
        print("🚀 Переходим к плану Б: Грузим данные напрямую из каталога")
        
        do {
                let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/collections")!
                var request = URLRequest(url: url)
                request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                // ДЕБАГ: Посмотрим, что там за словарь вместо массива
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("DEBUG: Получено от сервера: \(jsonString)")
                }

                // Если прилетает ошибка в виде словаря {"error": "..."}, декодер на [NFTCollection] упадет
                let collections = try JSONDecoder().decode([NFTCollection].self, from: data)
                
                let firstNftIds = Array(collections.first?.nfts.prefix(3) ?? [])
                let items = try await cartService.fetchNFTs(by: firstNftIds)
                
                // Обновляем UI в главном потоке
                await MainActor.run {
                    self.nfts = items.map { item in
                        CartModel(id: item.id, name: item.name, image: item.images.first ?? "", rating: item.rating, price: item.price)
                    }
                }
            } catch {
                print("❌ Ошибка декодирования: \(error)")
            }
        }

    func deleteItem(_ item: CartModel) async {
        nfts.removeAll { $0.id == item.id }
        try? await cartService.updateOrder(nftIds: nfts.map { $0.id })
    }
}
