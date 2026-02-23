//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 10.02.26.
//

import SwiftUI

struct CartView: View {
    // MARK: - Properties

    @StateObject private var viewModel = CartViewModel()
    @State var listData: [CartModel] = [] // Public for preview support
    @State var cartPath = NavigationPath()
    @State private var isShowingSortMenu = false
    @State private var isShowingDeleteAlert = false
    @State private var itemToDelete: CartModel?

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $cartPath) {
            ZStack {
                VStack {
                    if viewModel.nfts.isEmpty { emptyState }
                    else { list
                        Spacer()
                        makeOrder
                    }
                    Spacer()
                }

                // MARK: - Delete Alert

                if isShowingDeleteAlert {
                    Color.clear
                        .ignoresSafeArea(.all)
                        .transition(.opacity)
                        .background(.ultraThinMaterial)
                        .zIndex(1)

                    DeleteView(
                        imageName: itemToDelete?.image ?? ""
                        , onDelete: {
                            if let item = itemToDelete {
                                deleteItem(item)
                            }
                            withAnimation(.spring(duration: 0.2)) {
                                isShowingDeleteAlert = false
                                itemToDelete = nil
                            }
                        },
                        onCancel: { withAnimation(.spring(duration: 0.2)) {
                            isShowingDeleteAlert = false
                            itemToDelete = nil
                        }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(2)
                }
            }
            .background(.whiteAdaptive)

            // MARK: - Toolbar

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { withAnimation { isShowingSortMenu = true }}) {
                        Image(.sort)
                            .renderingMode(.template)
                            .foregroundStyle(.blackAdaptive)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                    }
                }
            }
            .navigationDestination(for: CartRoute.self) { route in
                switch route {
                case .payment:
                    PaymentView(cartPath: $cartPath)
                        .toolbar(.hidden, for: .tabBar)
                case .success:
                    PaymentSuccessView(cartPath: $cartPath)
                        .toolbar(.hidden, for: .tabBar)
                        .navigationBarBackButtonHidden()
                }
            }

            // MARK: - Sorting Overlay

            .overlay(SortMenuView(isShowingSortMenu: $isShowingSortMenu, title: "Сортировка", options: sortOptions, closeButtonTitle: "Закрыть"))
            .toolbar(shouldShowTabBar() ? .hidden : .visible, for: .tabBar)
            .toolbar(isShowingDeleteAlert ? .hidden : .visible)
        }
        .background(.whiteAdaptive)
        .task {
            await viewModel.loadCart()
        }
    }

    // MARK: - UI Components

    private var list: some View {
        List {
            ForEach(listData) { item in
                CartCell(
                    name: item.name,
                    image: item.image,
                    rating: item.rating,
                    price: item.price,
                    deleteAction: {
                        itemToDelete = item
                        isShowingDeleteAlert = true
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

    private var makeOrder: some View {
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

            Button(action: {
                cartPath.append(CartRoute.payment)
            }) {
                Text("К оплате")
                    .foregroundStyle(.whiteAdaptive)
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: 240, maxHeight: 44)
                    .background(.blackAdaptive)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding()
        .background(.lightGrayAdaptive)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var emptyState: some View {
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

    // MARK: - Computed Properties

    private func shouldShowTabBar() -> Bool {
        isShowingSortMenu || isShowingDeleteAlert || !cartPath.isEmpty
    }

    private var totalPrice: Double {
            viewModel.nfts.reduce(0) { $0 + $1.price }
        }

    private var formattedTotalPrice: String {
        String(format: "%.2f", totalPrice).replacingOccurrences(of: ".", with: ",")
    }

    private var sortOptions: [SortOption] {
        [
            SortOption(title: "По цене") {
                withAnimation { listData.sort {
                    $0.price < $1.price
                } }
            },
            SortOption(title: "По названию") {
                withAnimation { listData.sort { $0.name < $1.name } }
            },
            SortOption(title: "По рейтингу") {
                withAnimation { listData.sort { $0.rating > $1.rating } }
            },
        ]
    }

    // MARK: - Private Methods

    private func deleteItem(_ item: CartModel) {
        Task {
            await viewModel.deleteItem(item)
        }
    }
}

// MARK: - Preview

#Preview("Cart Light") {
    CartView(listData: [MockData.cartMock, MockData.cartMock2, MockData.cartMock3])
        .preferredColorScheme(.light)
}

#Preview("Cart Dark") {
    CartView(listData: [MockData.cartMock, MockData.cartMock2, MockData.cartMock3])
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
