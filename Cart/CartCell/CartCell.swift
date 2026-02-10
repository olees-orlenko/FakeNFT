//
//  CartCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 10.02.26.
//

import SwiftUI

struct CartCell: View {
    var name: String
    var image: String
    var rating : Int
    
    var body: some View {
        HStack {
            Image(name)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .padding(.bottom, 4)
                RatingView(rating: rating)
                    .padding(.bottom, 12)
                Text("Цена")
                    .padding(.bottom, 2)
                Text("1,78 ETH")
            }
            Spacer()
            Button(action: {}) {
                Image(.thrash)
            }
        }
    }
}

#Preview {
    CartCell(name: "April", image: "April", rating: 2)
}
