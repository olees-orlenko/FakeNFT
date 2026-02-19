//
//  RatingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 10.02.26.
//

import SwiftUI

struct RatingView: View {
    
    let rating: Int
    let maxRating: Int = 5
    let colorOpacity: Double = 0.3
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(.star)
                    .renderingMode(.template)
                    .foregroundStyle(index <= rating ? .yellow : .gray.opacity(colorOpacity))
            }
        }
    }
}

#Preview {
    RatingView(rating: 1)
}
