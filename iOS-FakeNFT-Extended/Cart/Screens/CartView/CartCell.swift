//
//  CartCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 10.02.26.
//

import SwiftUI

struct CartCell: View {
    let name: String
    let image: String
    let rating: Int
    let price: Double
    let deleteAction: () -> Void

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: image)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.1)
                    }
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 108)
                case .failure:
                    Image(.april)
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .clipped()

            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.blackAdaptive)
                    .padding(.bottom, 4)
                RatingView(rating: rating)
                    .padding(.bottom, 12)
                Text("Cart.price")
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
            .buttonStyle(.plain)
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
