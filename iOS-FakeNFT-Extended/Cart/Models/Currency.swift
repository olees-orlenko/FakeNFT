//
//  Currency.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 15.02.26.
//

import Foundation

struct Currency: Codable, Identifiable {
    let id: String
    let title: String
    let name: String
    let image: String
}

struct PaymentResponse: Codable {
    let success: Bool
    let id: String
    let orderId: String
}
