//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 10.02.26.
//

import SwiftUI

struct CartView: View {
    var listData: [CartModel]
    var body: some View {
        VStack {
            navbar
            if listData.isEmpty { emptyState }
            else { list
                Spacer()
                makeOrder
            }

            Spacer()
        }
    }

    var navbar: some View {
        HStack {
            Spacer()

            Button(action: {}) {
                Image(systemName: "line.horizontal.3")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal)
        }
    }

    var list: some View {
        List {
            ForEach(listData) { item in
                CartCell(name: item.name, image: item.image, rating: item.rating)
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
}

#Preview("Cart empty state") {
    CartView(listData: [])
}

#Preview("CartView") {
    CartView(listData: [cartMock,cartMock2,cartMock3,cartMock])
}
