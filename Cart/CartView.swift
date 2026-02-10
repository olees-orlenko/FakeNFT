//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 10.02.26.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        VStack {
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
            List {
                CartCell()
                    .listRowSeparator(.hidden)
                CartCell()
                    .listRowSeparator(.hidden)
                CartCell()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .listRowSpacing(16)
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("3 nft")
                        .font(.system(size: 15))
                    Text("5.17 ETH")
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
            Spacer()
        }
    }
}

#Preview {
    CartView()
}
