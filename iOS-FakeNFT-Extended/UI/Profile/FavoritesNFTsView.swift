import SwiftUI

struct FavoritesNFTsView: View {
    @Environment(\.dismiss) private var dismiss
    private let items: [FavoriteNFTItem]
    private let columns = [
        GridItem(.fixed(168), spacing: 7),
        GridItem(.fixed(168), spacing: 7)
    ]

    init(items: [FavoriteNFTItem] = FavoriteNFTItem.mock) {
        self.items = items
    }

    var body: some View {
        Group {
            if items.isEmpty {
                VStack {
                    Spacer()
                    Text("У Вас ещё нет избранных NFT")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                        ForEach(items) { item in
                            FavoriteNFTCard(item: item)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
        .navigationTitle("Избранные NFT")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                }
            }
        }
    }
}

private struct FavoriteNFTCard: View {
    let item: FavoriteNFTItem

    var body: some View {
        HStack(spacing: 12) {
            icon

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .lineLimit(1)
                starsView
                Text(item.price)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .lineLimit(1)
            }
        }
        .frame(width: 168, height: 80, alignment: .leading)
    }

    private var icon: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.35), Color.pink.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay {
                    Text(item.name.prefix(1))
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                }

            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color(uiColor: UIColor(hexString: "#F56B6C")))
                .padding(4)
        }
    }

    private var starsView: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { idx in
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(idx < item.rating ? Color.yellow : Color(uiColor: UIColor.systemGray5))
            }
        }
    }
}

struct FavoriteNFTItem: Identifiable {
    let id: String
    let name: String
    let rating: Int
    let price: String

    static let mock: [FavoriteNFTItem] = [
        FavoriteNFTItem(id: "1", name: "Archie", rating: 1, price: "1,78 ETH"),
        FavoriteNFTItem(id: "2", name: "Pixi", rating: 3, price: "1,78 ETH"),
        FavoriteNFTItem(id: "3", name: "Melissa", rating: 5, price: "1,78 ETH"),
        FavoriteNFTItem(id: "4", name: "April", rating: 2, price: "1,78 ETH"),
        FavoriteNFTItem(id: "5", name: "Daisy", rating: 1, price: "1,78 ETH"),
        FavoriteNFTItem(id: "6", name: "Lilo", rating: 4, price: "1,78 ETH")
    ]
}

#Preview {
    NavigationStack {
        FavoritesNFTsView()
    }
}

#Preview("Empty") {
    NavigationStack {
        FavoritesNFTsView(items: [])
    }
}
