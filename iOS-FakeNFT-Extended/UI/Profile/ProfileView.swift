import SwiftUI

struct ProfileView: View {
    private let viewData = ProfileViewData.mock

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    descriptionSection
                    linkSection
                    actionsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(Color.primary)
                    }
                    .frame(width: 42, height: 42)
                    .accessibilityLabel("Редактировать профиль")
                }
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .center, spacing: 16) {
            avatarView
            Text(viewData.name)
                .font(.system(size: 22, weight: .bold))
                .kerning(0.35)
                .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                .lineLimit(2)
                .lineSpacing(6)
        }
    }

    private var descriptionSection: some View {
        Text(viewData.description)
            .font(.system(size: 13, weight: .regular))
            .kerning(-0.08)
            .lineSpacing(5)
            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
            .fixedSize(horizontal: false, vertical: true)
    }

    private var linkSection: some View {
        Link(viewData.websiteTitle, destination: viewData.websiteURL)
            .font(.system(size: 15, weight: .regular))
            .foregroundStyle(Color.blue)
    }

    private var actionsSection: some View {
        VStack(spacing: 8) {
            NavigationLink {
                MyNFTsView()
            } label: {
                ProfileRowView(
                    title: "Мои NFT",
                    count: viewData.myNftCount
                )
            }
            .buttonStyle(.plain)

            ProfileRowView(
                title: "Избранные NFT",
                count: viewData.favoriteNftCount
            )
        }
        .padding(.top, 16)
    }

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color(.systemGray5))
            Text(viewData.initials)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(.systemGray))
        }
        .frame(width: 70, height: 70)
    }
}

private struct ProfileRowView: View {
    let title: String
    let count: Int

    var body: some View {
        HStack {
            Text("\(title) (\(count))")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color(.systemGray2))
        }
        .frame(height: 54)
        .padding(.horizontal, 16)
    }
}

private struct ProfileViewData {
    let name: String
    let description: String
    let websiteTitle: String
    let websiteURL: URL
    let myNftCount: Int
    let favoriteNftCount: Int

    var initials: String {
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }
        return String(initials)
    }

    static let mock = ProfileViewData(
        name: "Joaquin Phoenix",
        description: "Дизайнер из Казани, люблю цифровое искусство и бегать. В моей коллекции уже 100+ NFT, и еще больше — на моем сайте. Открыт к коллаборациям.",
        websiteTitle: "Joaquin Phoenix.com",
        websiteURL: URL(string: "https://example.com")!,
        myNftCount: 112,
        favoriteNftCount: 11
    )
}

#Preview {
    ProfileView()
}
