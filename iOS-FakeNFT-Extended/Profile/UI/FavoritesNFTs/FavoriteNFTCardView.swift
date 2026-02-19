import SwiftUI

// MARK: - FavoriteNFTCardView

struct FavoriteNFTCardView: View {
    // MARK: - Properties

    let item: FavoriteNFTItem
    let onLikeTap: () -> Void

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            icon

            VStack(alignment: .leading, spacing: 4) {
                name
                starsView
                price
            }
        }
        .frame(width: 168, height: 80, alignment: .leading)
    }

    // MARK: - Subviews

    private var name: some View {
        Text(item.name)
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
            .lineLimit(1)
    }

    private var price: some View {
        Text(item.price)
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
            .lineLimit(1)
    }

    private var icon: some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if let imageURL = item.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        placeholderImage
                    }
                } else {
                    placeholderImage
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Button(action: onLikeTap) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#F56B6C")))
                    .padding(4)
            }
            .buttonStyle(.plain)
        }
    }

    private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [Color.orange.opacity(0.35), Color.pink.opacity(0.35)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Text(item.name.prefix(1))
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
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

#Preview("Single Card") {
    FavoriteNFTCardView(
        item: FavoriteNFTItem(id: "preview1", name: "Archie", rating: 4, price: "1,78 ETH"),
        onLikeTap: {}
    )
    .padding()
}

#Preview("Catalog Slice") {
    VStack(spacing: 16) {
        ForEach(FavoriteNFTItem.catalog.prefix(3)) { item in
            FavoriteNFTCardView(item: item, onLikeTap: {})
        }
    }
    .padding()
}
