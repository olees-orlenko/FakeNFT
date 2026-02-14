//
//  NFTCollectionScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 14/02/26.
//

import SwiftUI

struct NFTCollectionScreen: View {
    
    struct NFTItem: Identifiable {
        let id = UUID()
        let title: String
        let rating: Int
        let price: String
    }
    
    @State private var likedItems: Set<UUID> = []
    
    let items: [NFTItem]
    var onBack: (() -> Void)? = nil
    
    private let columns = [
        GridItem(.fixed(108), spacing: 12),
        GridItem(.fixed(108), spacing: 12),
        GridItem(.fixed(108), spacing: 0)
    ]
    
    var body: some View {
        VStack(spacing: 26) {
            
            NavigationTitleView(
                title: "Коллекция NFT",
                systemImage: "chevron.left",
                buttonPosition: .left,
                titleAlignment: .center,
                onTap: { onBack?() }
            )
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(items) { item in
                        NFTCardView(
                            title: item.title,
                            rating: item.rating,
                            priceETH: item.price,
                            isLiked: Binding(
                                get: { likedItems.contains(item.id) },
                                set: { isLiked in
                                    if isLiked {
                                        likedItems.insert(item.id)
                                    } else {
                                        likedItems.remove(item.id)
                                    }
                                }
                            )
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 8)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NFTCollectionScreen(
        items: [
            .init(title: "Stella", rating: 4, price: "1.78"),
            .init(title: "Galaxy", rating: 5, price: "2.10"),
            .init(title: "Ocean", rating: 3, price: "0.98"),
            .init(title: "Neon", rating: 5, price: "3.45"),
            .init(title: "Dream", rating: 2, price: "1.12")
        ]
    )
}
