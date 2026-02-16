//
//  UserCardScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 14/02/26.
//

import SwiftUI

struct UserCardScreen: View {
    
    let avatarURL: URL?
    let name: String
    let about: String
    
    var onBack: (() -> Void)?
    var onOpenWebsite: (() -> Void)?
    var onNext: (() -> Void)?
    
    private let titleKey = "Statistic.nftCollectionTitle"
    
    var body: some View {
        VStack(spacing: 36) {
            
            NavigationTitleView(
                title: NSLocalizedString(titleKey, comment: ""),
                systemImage: "chevron.left",
                buttonPosition: .left,
                titleAlignment: .center,
                onTap: { onBack?() }
            )
            userInfoBlock
            websiteButton
            
            NavigationTitleView(
                title: "\(NSLocalizedString(titleKey, comment: "")) (112)",
                systemImage: "chevron.right",
                buttonPosition: .right,
                titleAlignment: .leading,
                onTap: { onNext?() }
            )
            
            Spacer()
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Blocks
    
    private var userInfoBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .center, spacing: 16) {
                avatarView
                
                Text(name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Spacer(minLength: 0)
            }
            .frame(height: 70)
            
            Text(about)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 343, alignment: .leading)
    }
    
    private var websiteButton: some View {
        Button {
            onOpenWebsite?()
        } label: {
            Text(NSLocalizedString("Statistic.openUserWebsite", comment: ""))
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(UIColor.segmentActive))
                .frame(width: 343, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(UIColor.segmentActive), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
    
    private var avatarView: some View {
        Group {
            if let avatarURL {
                AsyncImage(url: avatarURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                        .overlay(ProgressView())
                }
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.gray.opacity(0.6))
                    )
            }
        }
        .frame(width: 70, height: 70)
        .clipShape(Circle())
    }
}

#Preview {
    UserCardScreen(
        avatarURL: nil,
        name: "Joaquin Phoenix",
        about: "Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт  к коллаборациям."
    )
}
