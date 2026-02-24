//
//  PaymentService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 24.02.26.
//

import Foundation

extension CartService {
    func fetchCurrencies() async throws -> [Currency] {
        return try await performRequest(path: "api/v1/currencies")
    }

    func performPayment(currencyId: String) async throws -> Bool {
        let path = "api/v1/orders/1/payment/\(currencyId)"

        let response: PaymentResponse = try await performRequest(path: path)
        return response.success
    }
}
