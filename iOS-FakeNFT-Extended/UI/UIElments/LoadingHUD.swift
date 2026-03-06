//
//  LoadingHUD.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 10.02.2026.
//

import SwiftUI

struct LoadingHUD: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.loadingHUDColor))
                .frame(width: 82, height: 82)

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .tint(Color(.black))
                .scaleEffect(1.05)
                .frame(width: 30, height: 30)
        }
        .accessibilityLabel("Loading")
    }
}
