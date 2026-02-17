//
//  AddToCartButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 17.02.2026.
//

import SwiftUI

// MARK: - AddToCartButton

struct AddToCartButton: View {
    
    // MARK: - Properties
    
    @Binding var isInCart: Bool
    
    // MARK: - Body
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                isInCart.toggle()
            }
        } label: {
            Image(isInCart ? "trash" : "Cart")
                .foregroundColor(.primary)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(isInCart ? "InCart" : "Not InCart")
        .contentShape(Rectangle())
        .padding(.trailing, 12)
    }
}
