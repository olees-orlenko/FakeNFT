//
//  NFTCollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 16.02.2026.
//

import SwiftUI

// MARK: - NFT Collection View

struct NFTCollectionView: View {
    let collection: NFTCollection
    let items: [NFTItem]
    
    // MARK: - Properties
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 9), count: 3)
    private let horizontalPadding: CGFloat = 16
    @State private var isShowingAuthorWeb = false
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            coverView
            VStack(alignment: .leading, spacing: 16) {
                titleView
                    .padding(.top, 8)
                VStack(alignment: .leading, spacing: 8) {
                    authorView
                    descriptionView
                }
                collectionView
                    .padding(.top, 8)
            }
            .padding(.horizontal, horizontalPadding)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .fullScreenCover(isPresented: $isShowingAuthorWeb) {
            NavigationStack {
                ProfileWebView(url: authorURL)
                    .toolbar {
                        toolbarButton
                    }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarTitleDisplayMode(.inline)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarButton
        }
    }
    
    // MARK: - Subviews
    
    private var toolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .tint(.primary)
            }
        }
    }
    
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
                .frame(height: 310)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .ignoresSafeArea(edges: .top)
            } else {
                ZStack {
                    Color(.secondarySystemBackground)
                        .foregroundColor(.gray)
                }
                .frame(height: 310)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .ignoresSafeArea(edges: .top)
            }
        }
    }
    
    private var titleView: some View {
        Text(collection.title)
            .font(Font(UIFont.headline3))
    }
    
    private var authorView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(NSLocalizedString("Author", comment: ""))
                .font(Font(UIFont.caption2))
                .foregroundColor(.primary)
            Button(action: {
                isShowingAuthorWeb = true
            }) {
                Text(collection.authorName ?? "John Doe")
                    .font(Font(UIFont.caption1))
                    .foregroundColor(Color.blue)
            }
        }
    }
    
    private var descriptionView: some View {
        Text(collection.description ?? "")
            .font(Font(UIFont.caption2))
            .foregroundColor(.primary)
    }
    
    private var collectionView: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(items) { item in
                NftCell(
                    name: item.name,
                    image: item.image,
                    rating: item.rating,
                    price: item.price,
                    deleteAction: { }
                )
            }
        }
    }
    
    private var authorURL: URL {
        if let authorURL = collection.authorURL {
            return authorURL
        } else {
            return URL(string: "https://practicum.yandex.ru/ios-developer/")!
        }
    }
}

// MARK: - Preview

#Preview("NFT Collection") {
    Group {
        NFTCollectionView(
            collection: NFTCollection.mockCollections[0],
            items: NFTItem.mockItems
        )
    }
}
