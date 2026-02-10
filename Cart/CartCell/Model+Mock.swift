//
//  Model+Mock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 11.02.26.
//

import Foundation

struct CartModel: Identifiable {
    var id = UUID()
    let name: String
    let image: String
    let rating : Int
//    let price: Double 
}

let cartMock = CartModel(name: "April", image: "April", rating: 3)
let cartMock2 = CartModel(name: "Greena", image: "Greena", rating: 4)
let cartMock3 = CartModel(name: "Spring", image: "Spring", rating: 5)
