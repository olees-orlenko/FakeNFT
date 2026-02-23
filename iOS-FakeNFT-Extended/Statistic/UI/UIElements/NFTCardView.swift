import SwiftUI

struct NFTCardView: View {

    let title: String
    let rating: Int
    let priceETH: String
    let imageURL: URL?

    @Binding var isLiked: Bool

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            ZStack(alignment: .topTrailing) {

                nftImage
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()

                LikeButton(isLiked: $isLiked)
                    .padding(9)
            }

            RatingView(rating: rating)
                .frame(height: 12)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {

                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(UIColor.textPrimary))
                        .lineLimit(1)

                    Text("\(priceETH) ETH")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(UIColor.textPrimary))
                        .lineLimit(1)
                }
                .frame(width: 68, height: 40, alignment: .leading)

                Spacer(minLength: 0)

                Image("Cart")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(UIColor.segmentActive))
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .frame(width: 108, height: 40)
        }
        .frame(width: 108, height: 172)
    }

    // MARK: - Image

    @ViewBuilder
    private var nftImage: some View {
        if let imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.2)
                        .overlay(ProgressView())

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure(let error):
                    Image("NFT card")
                        .resizable()
                        .scaledToFill()
                        .overlay(
                            Text("img error")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.red)
                                .padding(6),
                            alignment: .bottomLeading
                        )
                    .onAppear {
                        print("❌ AsyncImage failed:", error.localizedDescription, "url:", imageURL.absoluteString)
                    }

                @unknown default:
                    Image("NFT card")
                        .resizable()
                        .scaledToFill()
                }
            }
        } else {
            Image("NFT card")
                .resizable()
                .scaledToFill()
                .overlay(
                    Text("no url")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.orange)
                        .padding(6),
                    alignment: .bottomLeading
                )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        NFTCardView(
            title: "Stella",
            rating: 4,
            priceETH: "1.78",
            imageURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"),
            isLiked: .constant(false)
        )
    }
}
