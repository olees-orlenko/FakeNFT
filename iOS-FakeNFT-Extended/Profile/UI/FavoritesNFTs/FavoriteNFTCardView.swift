import SwiftUI

struct FavoriteNFTCardView: View {
    let item: FavoriteNFTItem
    let onLikeTap: () -> Void

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
