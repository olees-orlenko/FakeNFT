//
//  PaymentViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 24.02.26.
//

import Foundation

@MainActor
final class PaymentViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var currencies: [Currency] = []
    @Published var selectedCurrency: Currency?
    @Published var isLoading = false
    @Published var paymentError = false

    private let service = CartService()

    // MARK: - Public Methods

    func loadCurrencies() async {
        isLoading = true
        defer { isLoading = false }

        do {
            currencies = try await service.fetchCurrencies()
        } catch {
            print("DEBUG: Ошибка валют: \(error)")
        }
    }

    func processPayment(nftIds: [String]) async -> Bool {
        guard let currencyId = selectedCurrency?.id else { return false }
        guard !nftIds.isEmpty else { return false }
        isLoading = true
        defer { isLoading = false }

        do {
            var seen = Set<String>()
            let uniqueIds = nftIds.filter { seen.insert($0).inserted }

            _ = try await service.updateOrder(nftIds: uniqueIds)

            let paymentSuccess = try await service.performPayment(currencyId: currencyId)
            guard paymentSuccess else { return false }

            for nftID in uniqueIds {
                _ = try await service.completeOrder(nftID: nftID)
            }

            return true
        } catch {
            paymentError = true
            return false
        }
    }
}
