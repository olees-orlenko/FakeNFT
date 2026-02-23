//
//  PaymentSuccessView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 16.02.26.
//

import SwiftUI

struct PaymentSuccessView: View {
    @Binding var cartPath: NavigationPath
    
    var body: some View {
        VStack {
            Spacer()

            Image(.paymentSuccess)
            Text("Успех! Оплата прошла,\n поздравляем с покупкой!")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.blackAdaptive)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 36)

            Spacer()

            Button(action: {
                cartPath = NavigationPath()
            }) {
                Text("Вернутся в корзину")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.whiteAdaptive)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(RoundedRectangle(cornerRadius: 12).fill(.blackAdaptive))
            .padding()
        }
        .navigationBarBackButtonHidden()
        .background(.whiteAdaptive)
    }
}

#Preview("Payment Success View Light") {
    @Previewable @State var previewPath = NavigationPath()
    PaymentSuccessView(cartPath: $previewPath)
        .preferredColorScheme(.light)
}

#Preview("Payment Success View Dark") {
    @Previewable @State var previewPath = NavigationPath()
    PaymentSuccessView(cartPath: $previewPath)
        .preferredColorScheme(.dark)
}
