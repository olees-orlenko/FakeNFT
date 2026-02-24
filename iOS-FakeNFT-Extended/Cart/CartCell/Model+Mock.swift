//
//  Model+Mock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 11.02.26.
//

import Foundation

struct CartModel: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let rating: Int
    let price: Double
}

enum MockData {
    static let cartMock = CartModel(name: "April", image: "April", rating: 3, price: 3.14)
    static let cartMock2 = CartModel(name: "Greena", image: "Greena", rating: 4, price: 2.28)
    static let cartMock3 = CartModel(name: "Spring", image: "Spring", rating: 5, price: 3.22)
}
