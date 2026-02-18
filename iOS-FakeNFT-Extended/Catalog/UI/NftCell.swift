//
//  NftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 13.02.2026.
//

import SwiftUI

// MARK: - NftCell

struct NftCell: View {
    
    // MARK: - Properties
    
    let name: String
    let image: String
    let rating: Int
    let price: String
    @State private var isLiked = false
    @State private var isInCart = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .topTrailing) {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 108, height: 108)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                LikeButton(isLiked: $isLiked)
                    .padding(10)
            }
            RatingView(rating: rating)
                .padding(.leading, 2)
                .padding(.top, 4)
            HStack(alignment: .bottom) {
                Text(name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
                AddToCartButton(isInCart: $isInCart)
            }
            Text(price)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.primary)
            Spacer()
        }
        .frame(width: 108, height: 192, alignment: .topLeading)
    }
}

// MARK: - Preview

#Preview {
    NftCell(name: "April", image: "April", rating: 2, price: "1 ETH")
}
