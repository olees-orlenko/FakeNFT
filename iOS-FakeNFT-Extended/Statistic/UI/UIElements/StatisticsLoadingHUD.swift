//
//  StatisticsLoadingHUD.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 03/03/26.
//

import SwiftUI

// MARK: - StatisticsLoadingHUD

struct StatisticsLoadingHUD: View {

    // MARK: - Body

    var body: some View {
        ZStack {
            // Прозрачная подложка, блокирующая взаимодействие
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { }

            // HUD с индикатором загрузки
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.loadingHUDColor))
                .frame(width: 82, height: 82)
                .overlay(
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.black)
                        .scaleEffect(1.05)
                        .frame(width: 30, height: 30)
                )
        }
        .accessibilityLabel("Loading")
        .transition(.opacity.combined(with: .scale))
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(.systemBackground).ignoresSafeArea()
        StatisticsLoadingHUD()
    }
}
