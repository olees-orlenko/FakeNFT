//
//  CollectionCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 05.02.2026.
//

import SwiftUI

// MARK: - Collection Cell

struct CollectionCell: View {
    
    // MARK: - Properties
    
    let collection: NFTCollection
    var cornerRadius: CGFloat = 12
    var coverHeight: CGFloat = 140
    var verticalPadding: CGFloat = 8
    
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
        Text("\(collection.title) (\(collection.itemCount))")
            .font(Font(UIFont.bodyBold))
            .foregroundColor(.primary)
            .lineLimit(1)
    }
}

// MARK: - Preview

#Preview("Cell light") {
    Group {
        CollectionCell(collection: NFTCollection.mockCollections[0])
            .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Cell dark") {
    Group {
        CollectionCell(collection: NFTCollection.mockCollections[0])
            .padding()
    }
    .preferredColorScheme(.dark)
}
