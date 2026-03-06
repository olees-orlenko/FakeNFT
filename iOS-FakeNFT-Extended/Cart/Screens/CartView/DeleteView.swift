//
//  DeleteView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 11.02.26.
//

import SwiftUI

struct DeleteView: View {
    var imageName: String
    let onDelete: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageName)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.1)
                    }
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 108)
                case .failure:
                    Image(.april)
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 108, height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("Cart.deleteConfirm")
                .foregroundStyle(.blackAdaptive)
                .font(.system(size: 13, weight: .regular))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            HStack(alignment: .center, spacing: 8) {
                Button(action: onDelete) {
                    Text("Cart.delete")
                        .foregroundStyle(.ypRed)
                }
                .frame(width: 127)
                .padding()
                .background(.blackAdaptive)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button(action: onCancel) {
                    Text("Cart.cancel")
                        .foregroundStyle(.whiteAdaptive)
                }
                .frame(width: 127)
                .padding()
                .background(.blackAdaptive)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

#Preview("Delete view light") {
    DeleteView(imageName: "April", onDelete: {}, onCancel: {})
        .preferredColorScheme(.light)
}

#Preview("Delete view dark") {
    DeleteView(imageName: "April", onDelete: {}, onCancel: {})
        .preferredColorScheme(.dark)
}
