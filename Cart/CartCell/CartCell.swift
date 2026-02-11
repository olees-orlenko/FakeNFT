//
//  CartCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 10.02.26.
//

import SwiftUI

struct CartCell: View {
    var name: String
    var image: String
    var rating: Int
    var price: Double
    var deleteAction: () -> Void

    var body: some View {
        HStack {
            Image(name)

            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.blackAdaptive)
                    .padding(.bottom, 4)
                RatingView(rating: rating)
                    .padding(.bottom, 12)
                Text("Цена")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.blackAdaptive)
                    .padding(.bottom, 2)
                Text("\(String(format: "%.2f", price).replacingOccurrences(of: ".", with: ",")) ETH")
                    .foregroundStyle(.blackAdaptive)
                    .font(.system(size: 17, weight: .bold))
            }
            Spacer()
            Button(action: deleteAction) {
                Image(.thrash)
                    .renderingMode(.template)
                    .foregroundStyle(.blackAdaptive)
            }
        }
        .background(.whiteAdaptive)
    }
}

#Preview("Cart cell light") {
    CartCell(name: "April", image: "April", rating: 2, price: 3.14, deleteAction: {})
        .preferredColorScheme(.light)
}

#Preview("Cart cell dark") {
    CartCell(name: "April", image: "April", rating: 2, price: 3.14, deleteAction: {})
        .preferredColorScheme(.dark)
}
