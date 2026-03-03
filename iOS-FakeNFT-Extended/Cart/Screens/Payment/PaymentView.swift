//
//  PaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 15.02.26.
//

import SwiftUI

private let purchaseDidCompleteNotification = Notification.Name("purchaseDidComplete")

struct PaymentView: View {
    @Binding var cartPath: NavigationPath
    let nftIds: [String]
    @EnvironmentObject private var cartManager: CartManager
    @State private var isAlertShowed: Bool = false
    @StateObject private var viewModel = PaymentViewModel()

    let columns = Array(repeating: GridItem(.flexible(), spacing: 7), count: 2)

    var body: some View {
        VStack {
            paymentMethods
                .padding()
            Spacer()
            paymentConfirm
                .alert("Payment.alert", isPresented: $isAlertShowed) {
                    Button("Cart.cancel", role: .cancel) { isAlertShowed = false }
                    Button("Common.retry") { validation() } 
                }
        }
        .task {
            await viewModel.loadCurrencies()
        }
        .background(.whiteAdaptive)
        .navigationTitle("Payment.title")
    }

    // MARK: - UI Components

    private var paymentMethods: some View {
        LazyVGrid(columns: columns, spacing: 7) {
            ForEach(viewModel.currencies) { currency in
                PaymentCell(
                    name: currency.title,
                    shortName: currency.name,
                    imageName: currency.image,
                    isSelected: viewModel.selectedCurrency?.id == currency.id,
                    action: {
                        viewModel.selectedCurrency = currency
                    }
                )
            }
        }
    }

    private var paymentConfirm: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Payment.agreement")
                .font(.system(size: 13))
                .padding([.leading, .top])
            Text("Payment.link")
                .font(.system(size: 13))
                .foregroundStyle(.link)
                .padding(.leading)

            Button(action: { validation() }) {
                Text("Payment.pay")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.whiteAdaptive)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(.blackAdaptive))
            .padding()
        }
        .background(
            Color.lightGrayAdaptive
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 12,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 12
                    )
                )
                .ignoresSafeArea()
        )
    }

    // MARK: - Private Func

    private func validation() {
        if viewModel.selectedCurrency != nil {
            Task {
                let success = await viewModel.processPayment(nftIds: nftIds)
                if success {
                    cartManager.markPurchased(ids: nftIds)
                    await cartManager.refreshFromServer()
                    NotificationCenter.default.post(name: purchaseDidCompleteNotification, object: nil)
                    cartPath.append(CartRoute.success)
                } else {
                    isAlertShowed = true
                }
            }
        } else {
            isAlertShowed = true
        }
    }
}

// MARK: - Preview

#Preview("Payment View Light") {
    @Previewable @State var previewPath = NavigationPath()
    PaymentView(cartPath: $previewPath, nftIds: [])
        .environmentObject(CartManager())
        .preferredColorScheme(.light)
}

#Preview("Payment View Dark") {
    @Previewable @State var previewPath = NavigationPath()
    PaymentView(cartPath: $previewPath, nftIds: [])
        .environmentObject(CartManager())
        .preferredColorScheme(.dark)
}
