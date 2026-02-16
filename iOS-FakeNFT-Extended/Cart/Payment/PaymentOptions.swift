//
//  PaymentOptions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 15.02.26.
//

import Foundation

struct PaymentOptions: Identifiable {
    let id = UUID()
    let name: String
    let shortName: String
    let icon: String

    static let allOptions: [PaymentOptions] = [
        PaymentOptions(name: "Bitcoin", shortName: "BTC", icon: "Bitcoin"),
        PaymentOptions(name: "Dogecoin", shortName: "DOGE", icon: "Dogecoin"),
        PaymentOptions(name: "Tether", shortName: "USDT", icon: "Tether"),
        PaymentOptions(name: "ApeCoin", shortName: "APE", icon: "ApeCoin"),
        PaymentOptions(name: "Solana", shortName: "SOL", icon: "Solana"),
        PaymentOptions(name: "Ethereum", shortName: "ETH", icon: "Ethereum"),
        PaymentOptions(name: "Cardano", shortName: "ADA", icon: "Cardano"),
        PaymentOptions(name: "Shiba Inu", shortName: "SHIB", icon: "Shiba Inu"),
    ]
}
