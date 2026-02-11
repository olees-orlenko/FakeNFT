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
            .background(.whiteAdaptive)
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
        .overlay(SortMenuView(isShowingSortMenu: $isShowingSortMenu, title: "Сортировка", options: sortOptions, closeButtonTitle: "Закрыть"))
        .toolbar(isShowingSortMenu ? .hidden : .visible, for: .tabBar)
    }

    var list: some View {
        List {
            ForEach(listData) { item in
                CartCell(
                    name: item.name,
                    image: item.image,
                    rating: item.rating,
                    price: item.price,
                    deleteAction: {
                        itemToDelete = item
                        showDeleteAlert = true
                    }
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.whiteAdaptive)
            }
        }
        .background(.whiteAdaptive)
        .listStyle(.plain)
        .listRowSpacing(16)
    }

    var makeOrder: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(listData.count) NFT")
                    .font(.system(size: 15))
                    .foregroundStyle(.blackAdaptive)
                Text("\(formattedTotalPrice) ETH")
                    .foregroundStyle(.ypGreen)
                    .font(.system(size: 17, weight: .bold))
                    .lineLimit(1)
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {}) {
                Text("К оплате")
                    .foregroundStyle(.whiteAdaptive)
                    .font(.system(size: 17, weight: .bold))
            }
            .frame(maxWidth: 240, maxHeight: 44)
            .background(.blackAdaptive)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            .padding(.trailing)
        }
        .padding()
        .background(.lightGrayAdaptive)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    var emptyState: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("Корзина пуста")
                    .foregroundStyle(.blackAdaptive)
                    .font(.system(size: 17, weight: .bold))
                Spacer()
            }
            Spacer()
        }
        .background(.whiteAdaptive)
    }

    private var totalPrice: Double {
        listData.reduce(0) { $0 + $1.price }
    }
    private var formattedTotalPrice: String {
        String(format: "%.2f", totalPrice).replacingOccurrences(of: ".", with: ",")
    }

    private var sortOptions: [SortOption] {
        [
            SortOption(title: "По цене") {
                withAnimation { listData.sort {
                    $0.price < $1.price } }
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

#Preview("Cart Light") {
    CartView(listData: [cartMock, cartMock2, cartMock3, cartMock])
        .preferredColorScheme(.light)
}

#Preview("Cart Dark") {
    CartView(listData: [cartMock, cartMock2, cartMock3, cartMock])
        .preferredColorScheme(.dark)
}

#Preview("Cart empty state light") {
    CartView(listData: [])
        .preferredColorScheme(.light)
}

#Preview("Cart empty state dark") {
    CartView(listData: [])
        .preferredColorScheme(.dark)
}
