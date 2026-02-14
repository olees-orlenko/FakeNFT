//
//  LikeButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 13.02.2026.
//

import SwiftUI

// MARK: - LikeButton

struct LikeButton: View {
    
    // MARK: - Properties
    
    @Binding var isLiked: Bool
    
    // MARK: - Body
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                isLiked.toggle()
            }
        } label: {
            Image(isLiked ? "heart" : "white_heart")
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 18)
                .foregroundColor(isLiked ? .red : .white)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(isLiked ? "Liked" : "Not liked")
        
    }
}

// MARK: - Preview

#Preview("Liked") {
    LikeButton(isLiked: .constant(true))
}

#Preview("Not liked") {
    LikeButton(isLiked: .constant(false))
        .background(Color(.red))
}
