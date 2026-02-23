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
    @State private var selectedMethod: PaymentOptions?

    let columns = Array(repeating: GridItem(.flexible(), spacing: 7), count: 2)

    var body: some View {
        VStack {
            paymentMethods
                .padding()
            Spacer()
            paymentConfirm
                .alert("Не удалось произвести оплату", isPresented: $isAlertShowed) {
                    Button("Отмена", role: .cancel) { isAlertShowed = false }
                    Button("Повторить") {} // make retry logic
                }
        }
        .background(.whiteAdaptive)
        .navigationTitle("Выберите способ оплаты")
    }

    // MARK: - UI Components

    private var paymentMethods: some View {
        LazyVGrid(columns: columns, spacing: 7) {
            ForEach(PaymentOptions.allOptions) { option in
                PaymentCell(
                    name: option.name,
                    shortName: option.shortName,
                    imageName: option.icon,
                    isSelected: selectedMethod?.id == option.id,
                    action: {
                        selectedMethod = option
                    }
                )
            }
        }
    }

    private var paymentConfirm: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Совершая покупку, вы соглашаетесь с условиями")
                .font(.system(size: 13))
                .padding([.leading, .top])
            Text("Пользовательского соглашения")
                .font(.system(size: 13))
                .foregroundStyle(.link)
                .padding(.leading)

            Button(action: { validation() }) {
                Text("Оплатить")
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
        // MARK: - Add data validation

        if selectedMethod != nil {
            cartPath.append(CartRoute.success)
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
