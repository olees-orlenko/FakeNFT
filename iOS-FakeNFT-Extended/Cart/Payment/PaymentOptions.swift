//
//  PaymentOptions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 15.02.26.
//

import Foundation

struct PaymentOptions {
    let name: String
    let shortName: String
    let icon: String
}

enum PaymentMethods {
    static let bitcoin = PaymentOptions(name: "Bitcoin", shortName: "BTC", icon: "Bitcoin")
    static let apeCoin = PaymentOptions(name: "ApeCoin", shortName: "APE", icon: "ApeCoin")
    static let dogecoin = PaymentOptions(name: "Dogecoin", shortName: "DOGE", icon: "Dogecoin")
    static let tether = PaymentOptions(name: "Tether", shortName: "USDT", icon: "Tether")
    static let solana = PaymentOptions(name: "Solana", shortName: "SOL", icon: "Solana")
    static let ethereum = PaymentOptions(name: "Ethereum", shortName: "ETH", icon: "Ethereum")
    static let cardano = PaymentOptions(name: "Cardano", shortName: "ADA", icon: "Cardano")
    static let shibaInu = PaymentOptions(name: "Shiba Inu", shortName: "ADA", icon: "Shiba Inu")
}
