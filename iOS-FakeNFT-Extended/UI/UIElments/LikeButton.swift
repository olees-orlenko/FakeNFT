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
    
    let isLiked: Bool
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
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

//#Preview("Liked") {
//    LikeButton(isLiked: .constant(true))
//}
//
//#Preview("Not liked") {
//    LikeButton(isLiked: .constant(false))
//        .background(Color(.red))
//}
