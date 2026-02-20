//
//  CatalogCollectionCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 05.02.2026.
//

import SwiftUI

// MARK: - Catalog Collection Cell

struct CatalogCollectionCell: View {
    
    // MARK: - Properties
    
    private let collection: NFTCollection
    private let cornerRadius: CGFloat = 12
    private let coverHeight: CGFloat = 140
    private let verticalPadding: CGFloat = 8
    
    // MARK: - Init
    
    init(collection: NFTCollection) {
            self.collection = collection
        }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            coverView
            titleView
        }
        .padding(.vertical, verticalPadding)
    }
    
    // MARK: - Subviews
    
    private var coverView: some View {
        Group {
            if let url = collection.coverURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color(.secondarySystemBackground)
                }
                .frame(height: coverHeight)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            } else {
                ZStack {
                    Color(.secondarySystemBackground)
                    Image(systemName: "photo")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                }
                .frame(height: coverHeight)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            }
        }
    }
    
    private var titleView: some View {
        Text("\(collection.title) (\(Set(collection.nfts).count))")
            .font(Font(UIFont.bodyBold))
            .foregroundColor(.primary)
            .lineLimit(1)
    }
}

// MARK: - Preview

//#Preview("Cell light") {
//    Group {
//        CatalogCollectionCell(collection: NFTCollection.mockCollections[0])
//            .padding()
//    }
//    .preferredColorScheme(.light)
//}
//
//#Preview("Cell dark") {
//    Group {
//        CatalogCollectionCell(collection: NFTCollection.mockCollections[0])
//            .padding()
//    }
//    .preferredColorScheme(.dark)
//}
