//
//  Model+Mock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 11.02.26.
//

import Foundation

struct CartModel: Identifiable {
    let id: String
    let name: String
    let image: String
    let rating: Int
    let price: Double
}

enum MockData {
    static let cartMock = CartModel(id: "1", name: "April", image: "April", rating: 3, price: 3.14)
    static let cartMock2 = CartModel(id: "2",name: "Greena", image: "Greena", rating: 4, price: 2.28)
    static let cartMock3 = CartModel(id: "3",name: "Spring", image: "Spring", rating: 5, price: 3.22)
}
