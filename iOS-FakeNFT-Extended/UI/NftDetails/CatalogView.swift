//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 06.02.2026.
//

import SwiftUI

// MARK: - CatalogView

struct CatalogView: View {
    
    // MARK: - Properties
    
    private let collections = NFTCollection.mockCollections
    @StateObject private var viewModel = CatalogViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(collections) { collection in
                            CollectionCell(collection: collection)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 20)
                }
                if viewModel.isLoading {
                    Color.clear
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture { }
                    LoadingHUD()
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { }) {
                        Image("Menu")
                            .foregroundColor(.primary)
                            .padding(1.3)
                    }
                }
            }
        }
        .task {
            await viewModel.loadCovers()
        }
    }
}

// MARK: - Preview

#Preview("Catalog light") {
    Group {
        CatalogView()
    }
    .preferredColorScheme(.light)
}

#Preview("Catalog dark") {
    Group {
        CatalogView()
    }
    .preferredColorScheme(.dark)
}
