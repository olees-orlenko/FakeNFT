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
    
    @StateObject private var viewModel = CatalogViewModel()
    @State private var isShowingSortMenu = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.collections) { collection in
                            CollectionCell(collection: collection)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.bottom, isShowingSortMenu ? 32 : 0)
                if viewModel.isLoading {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture { }
                    LoadingHUD()
                        .transition(.opacity.combined(with: .scale))
                }
                if isShowingSortMenu {
                    CollectionFilter(
                        isPresented: $isShowingSortMenu,
                        onSortByName: { viewModel.sort(by: .byName(ascending: true)) },
                        onSortByCount: { viewModel.sort(by: .byCount(ascending: false)) }
                    )
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingSortMenu = true
                    } label: {
                        Image("Menu")
                            .foregroundColor(.primary)
                            .padding(1.3)
                    }
                }
            }
            .toolbar(isShowingSortMenu ? .hidden : .visible, for: .tabBar)
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
