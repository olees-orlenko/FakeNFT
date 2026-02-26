//
//  PaymentCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 15.02.26.
//

import SwiftUI

struct PaymentCell: View {
    let name: String
    let shortName: String
    let imageName: String
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            AsyncImage(url: URL(string: imageName)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.1)
                    }
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36)
                case .failure:
                    Image(.april)
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.system(size: 13))
                    .foregroundStyle(.blackAdaptive)
                Text(shortName)
                    .font(.system(size: 13))
                    .foregroundStyle(.ypGreen)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(RoundedRectangle(cornerRadius: 12).fill(.lightGrayAdaptive))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(isSelected ? Color.blackAdaptive : Color.clear, lineWidth: 2))
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }
    }
}

#Preview("Payment Cell Light") {
    PaymentCell(name: "Bitcoin", shortName: "BTC", imageName: "Bitcoin", isSelected: false, action: {})
}

#Preview("Payment Cell Dark") {
    PaymentCell(name: "Bitcoin", shortName: "BTC", imageName: "Bitcoin", isSelected: false, action: {})
        .preferredColorScheme(.dark)
}
