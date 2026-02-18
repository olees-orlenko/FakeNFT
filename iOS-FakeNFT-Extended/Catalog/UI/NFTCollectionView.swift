//
//  NFTCollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 16.02.2026.
//

import SwiftUI

// MARK: - NFT Collection View

struct NFTCollectionView: View {
    
    // MARK: - Properties
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 9), count: 3)
    private let horizontalPadding: CGFloat = 16
    @State private var isShowingAuthorWeb = false
    @State private var showLoadingError = false
    @StateObject private var viewModel: NftViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Init
    
    init(collection: NFTCollection) {
        _viewModel = StateObject(wrappedValue: NftViewModel(collection: collection))
    }
    
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
                ProfileWebView(url: viewModel.authorURL)
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
        .task {
            do {
                try await viewModel.loadItems()
            } catch {
                showLoadingError = true
            }
        }
        .alert(
            NSLocalizedString("alert.title", comment: ""),
            isPresented: $showLoadingError
        ) {
            Button {
                Task {
                    do {
                        try await viewModel.loadItems()
                    } catch {
                        showLoadingError = true
                    }
                }
            } label: {
                Text(NSLocalizedString("alert.retry", comment: ""))
            }
            
            Button(role: .cancel) { } label: {
                Text(NSLocalizedString("alert.cancel", comment: ""))
            }
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
            if let url = viewModel.collection.coverURL {
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
        Text(viewModel.collection.title)
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
                Text(viewModel.collection.authorName ?? "John Doe")
                    .font(Font(UIFont.caption1))
                    .foregroundColor(Color.blue)
            }
        }
    }
    
    private var descriptionView: some View {
        Text(viewModel.collection.description ?? "")
            .font(Font(UIFont.caption2))
            .foregroundColor(.primary)
    }
    
    private var collectionView: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(viewModel.items) { item in
                NftCell(
                    name: item.name,
                    image: item.image,
                    rating: item.rating,
                    price: item.price
                )
            }
        }
    }
}

// MARK: - Preview

#Preview("NFT Collection") {
    Group {
        NFTCollectionView(
            collection: NFTCollection.mockCollections[0]
        )
    }
}
