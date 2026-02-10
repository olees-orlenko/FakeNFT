//
//  CartCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 10.02.26.
//

import SwiftUI

struct CartCell: View {
    var body: some View {
        HStack {
            Image(.nftPlaceholder)
                .padding()
            VStack(alignment: .leading, spacing: 0) {
                Text("April")
                    .padding(.bottom, 4)
                RatingView(rating: 3)
                    .padding(.bottom, 12)
                Text("Цена")
                    .padding(.bottom, 2)
                Text("1,78 ETH")
            }
            Spacer()
            Button(action: {}) {
                Image(.thrash)
            }
            .padding()
        }
    }
}

#Preview {
    CartCell()
}
