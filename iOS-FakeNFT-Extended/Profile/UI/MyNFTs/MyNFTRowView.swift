import SwiftUI

// MARK: - MyNFTRowView

struct MyNFTRowView: View {
    let item: MyNFTItem
    let isFavorite: Bool
    let onLikeTap: () -> Void

    // MARK: - Body

    var body: some View {
        HStack(spacing: 16) {
            imageBlock

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 17, weight: .bold))
                    .lineLimit(1)
                starsView
                Text("от \(item.author)")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
            }

            Spacer()

            VStack(alignment: .leading, spacing: 2) {
                Text("Цена")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                Text(item.price)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .lineLimit(1)
            }
            .frame(width: 112, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .frame(height: 140)
    }

    // MARK: - Subviews

    private var imageBlock: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.pink.opacity(0.3), Color.purple.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 108, height: 108)
                .overlay {
                    Text(item.name.prefix(1))
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                }

            Button(action: onLikeTap) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(
                        isFavorite
                        ? Color(uiColor: UIColor(hexString: "#F56B6C"))
                        : .white
                    )
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
    }

    private var starsView: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { idx in
                Image(systemName: idx < item.rating ? "star.fill" : "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(idx < item.rating ? Color.yellow : Color(uiColor: UIColor.systemGray5))
            }
        }
    }
}
