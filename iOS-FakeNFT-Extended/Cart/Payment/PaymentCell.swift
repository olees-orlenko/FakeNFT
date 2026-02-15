//
//  PaymentCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 15.02.26.
//

import SwiftUI

struct PaymentCell: View {
    let name: String
    let shortName: String
    let image: String

    var body: some View {
        HStack(spacing: 4) {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.system(size: 13))
                    .foregroundStyle(.blackAdaptive)
                Text(shortName)
                    .font(.system(size: 13))
                    .foregroundStyle(.ypGreen)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(RoundedRectangle(cornerRadius: 12).fill(.lightGrayAdaptive))
    }
}

#Preview("Payment Cell Light") {
    PaymentCell(name: "Bitcoin", shortName: "BTC", image: "Bitcoin")
}

#Preview("Payment Cell Dark") {
    PaymentCell(name: "Bitcoin", shortName: "BTC", image: "Bitcoin")
        .preferredColorScheme(.dark)
}
