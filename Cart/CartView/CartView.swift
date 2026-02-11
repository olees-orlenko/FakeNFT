//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 10.02.26.
//

import SwiftUI

struct CartView: View {
    @State var listData: [CartModel]

    @State private var isShowingSortMenu = false
    @State private var showDeleteAlert = false
    @State private var itemToDelete: CartModel?

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if listData.isEmpty { emptyState }
                    else { list
                        Spacer()
                        makeOrder
                    }
                    Spacer()
                }

                if showDeleteAlert {
                    Color.clear
                        .ignoresSafeArea(.all)
                        .transition(.opacity)
                        .background(.ultraThinMaterial)
                        .zIndex(1)

                    DeleteView(
                        onDelete: {
                            if let item = itemToDelete {
                                deleteItem(item)
                            }
                            withAnimation(.spring(duration: 0.2)) {
                                showDeleteAlert = false
                                itemToDelete = nil
                            }
                        },
                        onCancel: { withAnimation(.spring(duration: 0.2)) {
                            showDeleteAlert = false
                            itemToDelete = nil
                        }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(2)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { withAnimation { isShowingSortMenu = true }}) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundStyle(.black)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                    }
                }
            }
            .toolbar(showDeleteAlert ? .hidden : .visible, for: .tabBar)
        }
        .overlay(SortMenuView(isShowingSortMenu: $isShowingSortMenu, title: "Title", options: sortOptions, closeButtonTitle: "Cancel"))
        .toolbar(isShowingSortMenu ? .hidden : .visible, for: .tabBar)
    }

    var list: some View {
        List {
            ForEach(listData) { item in
                CartCell(
                    name: item.name,
                    image: item.image,
                    rating: item.rating,
                    deleteAction: {
                        itemToDelete = item
                        showDeleteAlert = true
                    }
                )
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .listRowSpacing(16)
    }

    var makeOrder: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(listData.count) nft")
                    .font(.system(size: 15))
                Text("5.17 ETH") // count price
                    .foregroundStyle(.green)
                    .font(.system(size: 17, weight: .bold))
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {}) {
                Text("to order")
                    .foregroundStyle(.white)
            }
            .frame(width: 240, height: 44)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            .padding(.horizontal)
        }
        .padding()
        .background(.gray.opacity(0.6)) // Change color
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    var emptyState: some View {
        VStack {
            Spacer()
            Text("Cart empty")
            Spacer()
        }
    }

    private var sortOptions: [SortOption] {
        [
            SortOption(title: "По цене") {
                withAnimation { }
            },
            SortOption(title: "По названию") {
                withAnimation { listData.sort { $0.name < $1.name } }
            },
            SortOption(title: "По рейтингу") {
                withAnimation { listData.sort { $0.rating > $1.rating } }
            },
        ]
    }

    private func deleteItem(_ item: CartModel) {
        if let index = listData.firstIndex(where: { $0.id == item.id }) {
            listData.remove(at: index)
        }
    }
}

#Preview("Cart empty state") {
    CartView(listData: [])
}

#Preview("CartView") {
    CartView(listData: [cartMock, cartMock2, cartMock3, cartMock])
}
