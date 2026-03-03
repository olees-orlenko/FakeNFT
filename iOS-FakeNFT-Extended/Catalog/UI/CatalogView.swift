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
    @State private var selectedCollection: NFTCollection?
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                List(viewModel.collections) { collection in
                    CatalogCollectionCell(collection: collection)
                        .onTapGesture {
                            selectedCollection = collection
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .padding(.top, 12)
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
                            .padding(9)
                    }
                }
            }
            .toolbar(isShowingSortMenu ? .hidden : .visible, for: .tabBar)
            .fullScreenCover(item: $selectedCollection) { collection in
                NavigationStack {
                    NFTCollectionView(collection: collection)
                }
            }
            .task {
                await viewModel.loadCovers()
            }
            .alert(
                NSLocalizedString("alert.title", comment: ""),
                isPresented: $viewModel.errorAlertPresented
            ) {
                Button {
                    Task {
                        await viewModel.loadCovers()
                    }
                } label: {
                    Text(NSLocalizedString("alert.retry", comment: ""))
                }
                
                Button(role: .cancel) { } label: {
                    Text(NSLocalizedString("alert.cancel", comment: ""))
                }
            }
        }
        .tint(.black)
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
