//
//  CartManager.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 20.02.2026.
//

import SwiftUI

final class CartManager: ObservableObject {
    
    // MARK: - Properties
    
    var count: Int {
        cartItems.count
    }
    @AppStorage("cartNFTs") private var cartIDsString: String = ""
    @Published private(set) var cartItems: Set<String> = []
    
    // MARK: - Init
    
    init() {
        let ids = cartIDsString.isEmpty ? [] : cartIDsString.split(separator: ",").map(String.init)
        cartItems = Set(ids)
    }
    
    // MARK: - Methods
    
    private func persist() {
        cartIDsString = cartItems.sorted().joined(separator: ",")
    }
    
    func isInCart(id: String) -> Bool {
        cartItems.contains(id)
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
    }
}
