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
    let imageURL: URL?
    let rating: Int
    let priceString: String
    let nftID: String
    @EnvironmentObject private var favoritesManager: FavoritesManager
    @EnvironmentObject private var cartManager: CartManager
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 108, height: 108)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } placeholder: {
                    Color(.secondarySystemBackground)
                        .frame(width: 108, height: 108)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        )
                }
                LikeButton(
                    isLiked: favoritesManager.isFavorite(id: nftID),
                    action: { favoritesManager.toggleFavorite(id: nftID) }
                )
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
                AddToCartButton(
                    isInCart: cartManager.isInCart(id: nftID),
                    action: { cartManager.toggleCart(id: nftID) }
                )
            }
            Text(priceString)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.primary)
            Spacer()
        }
        .frame(width: 108, height: 192, alignment: .topLeading)
    }
}
