//
//  PaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 15.02.26.
//

import SwiftUI

struct PaymentView: View {
    @Binding var cartPath: NavigationPath
    @State private var isAlertShowed: Bool = false
    @State private var isSuccessShowed: Bool = false
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
        .navigationBarBackButtonHidden(UIDevice.current.systemVersion.compare("26.0", options: .numeric) == .orderedAscending)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if #available(iOS 26.0, *) {}
                else {
                    Button(action: { cartPath.removeLast() }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.blackAdaptive)
                            .font(.title3)
                    }
                }
            }
        }
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
                let success = await viewModel.processPayment()
                if success {
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
    PaymentView(cartPath: $previewPath)
        .preferredColorScheme(.light)
}

#Preview("Payment View Dark") {
    @Previewable @State var previewPath = NavigationPath()
    PaymentView(cartPath: $previewPath)
        .preferredColorScheme(.dark)
}
