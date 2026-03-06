//
//  CartManager.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 20.02.2026.
//

import SwiftUI

@MainActor
final class CartManager: ObservableObject {
    
    // MARK: - Properties
    
    var count: Int {
        cartItems.count
    }
    private let defaults = UserDefaults.standard
    private let cartStorageKey = "cartNFTs"
    private let purchasedStorageKey = "purchasedNFTsOverride"
    @Published private(set) var cartItems: Set<String> = []
    private let cartService = CartService()
    private var isSyncInProgress = false
    private var pendingSync = false
    
    // MARK: - Init
    
    init() {
        let ids = cartIDsString.isEmpty ? [] : cartIDsString.split(separator: ",").map(String.init)
        cartItems = Set(ids)
        Task {
            await refreshFromServer()
        }
    }
    
    // MARK: - Methods

    private var cartIDsString: String {
        get { defaults.string(forKey: cartStorageKey) ?? "" }
        set { defaults.set(newValue, forKey: cartStorageKey) }
    }

    private var purchasedIDsString: String {
        get { defaults.string(forKey: purchasedStorageKey) ?? "" }
        set { defaults.set(newValue, forKey: purchasedStorageKey) }
    }
    
    private func persist() {
        cartIDsString = cartItems.sorted().joined(separator: ",")
    }

    private var purchasedIDs: Set<String> {
        let ids = purchasedIDsString.isEmpty ? [] : purchasedIDsString.split(separator: ",").map(String.init)
        return Set(ids)
    }

    private func persistPurchased(_ ids: Set<String>) {
        purchasedIDsString = ids.sorted().joined(separator: ",")
    }

    func getPurchasedIDs() -> Set<String> {
        purchasedIDs
    }

    func markPurchased(ids: [String]) {
        var purchased = purchasedIDs
        purchased.formUnion(ids)
        persistPurchased(purchased)

        cartItems.subtract(ids)
        persist()
    }
    
    func isInCart(id: String) -> Bool {
        cartItems.contains(id)
    }

    func replace(with ids: Set<String>) {
        cartItems = ids
        persist()
    }

    func refreshFromServer() async {
        do {
            let order = try await cartService.fetchOrder()
            replace(with: Set(order.nfts))
        } catch {
            print("❌ Ошибка синхронизации корзины: \(error)")
        }
    }

    private func scheduleSyncToServer() {
        if isSyncInProgress {
            pendingSync = true
            return
        }

        isSyncInProgress = true

        Task {
            await syncToServerLoop()
        }
    }

    private func syncToServerLoop() async {
        while true {
            let target = cartItems

            if target.isEmpty {
                do {
                    _ = try await cartService.clearOrder()
                    if cartItems == target {
                        replace(with: [])
                    }
                } catch {
                    print("❌ Ошибка очистки корзины: \(error)")
                }

                if pendingSync {
                    pendingSync = false
                    continue
                }

                if cartItems != target {
                    continue
                }

                break
            }

            do {
                let updated = try await cartService.updateOrder(nftIds: Array(target))
                if cartItems == target {
                    replace(with: Set(updated.nfts))
                }
            } catch {
                print("❌ Ошибка обновления корзины: \(error)")
            }

            if pendingSync {
                pendingSync = false
                continue
            }

            if cartItems != target {
                continue
            }

            break
        }

        isSyncInProgress = false
    }
    
    func addToCart(_ id: String) {
        cartItems.insert(id)
        persist()
    }
    
    func removeFromCart(_ id: String) {
        cartItems.remove(id)
        persist()
    }
    
    func toggleCart(id: String) {
        if cartItems.contains(id) {
            removeFromCart(id)
        } else {
            addToCart(id)
        }

        scheduleSyncToServer()
    }
}
