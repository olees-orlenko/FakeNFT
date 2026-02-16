//
//  PaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 15.02.26.
//

import SwiftUI

struct PaymentView: View {
    @State var isAlertShowed: Bool = false // Delete cuz it placeholder
    @State private var selectedMethod: PaymentOptions?

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
        .navigationTitle("Выберите способ оплаты")
    }

    private var paymentMethods: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]) {
            ForEach(PaymentOptions.allOptions) { option in
                PaymentCell(
                    name: option.name,
                    shortName: option.shortName,
                    image: option.icon,
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

            Button(action: {}) {
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
                .ignoresSafeArea(.all)
        )
    }
}

#Preview("Payment View Light") {
    PaymentView()
        .preferredColorScheme(.light)
}

#Preview("Payment View Dark") {
    PaymentView()
        .preferredColorScheme(.dark)
}
