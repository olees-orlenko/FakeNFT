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
    var isSelected: Bool
    let action: () -> Void

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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(RoundedRectangle(cornerRadius: 12).fill(.lightGrayAdaptive))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(isSelected ? Color.blackAdaptive : Color.clear, lineWidth: 2))
        .onTapGesture {
            action()
        }
    }
}

#Preview("Payment Cell Light") {
    PaymentCell(name: "Bitcoin", shortName: "BTC", image: "Bitcoin", isSelected: false, action: {})
}

#Preview("Payment Cell Dark") {
    PaymentCell(name: "Bitcoin", shortName: "BTC", image: "Bitcoin", isSelected: false, action: {})
        .preferredColorScheme(.dark)
}
