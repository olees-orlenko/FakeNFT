//
//  OrdersDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 24/02/26.
//
import Foundation

struct OrdersDTO: Decodable, Encodable {
    let id: String
    var nfts: [String]
}
