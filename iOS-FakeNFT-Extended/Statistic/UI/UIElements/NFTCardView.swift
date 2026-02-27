import SwiftUI

struct NFTCardView: View {

    let title: String
    let rating: Int
    let priceETH: String
    let imageURL: URL?

    @Binding var isLiked: Bool
    @Binding var isInCart: Bool

    let onTapLike: () -> Void
    let onTapCart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            ZStack(alignment: .topTrailing) {
                nftImage
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()

                LikeButton(isLiked: isLiked) {
                    onTapLike()
                }
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

                Button {
                    onTapCart()
                } label: {
                    Image(isInCart ? "CartBlack" : "Cart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(UIColor.segmentActive))
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
            }
            .frame(width: 108, height: 40)
        }
        .frame(width: 108, height: 172)
    }

    @ViewBuilder
    private var nftImage: some View {
        if let imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.2).overlay(ProgressView())
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Image("NFT card").resizable().scaledToFill()
                @unknown default:
                    Image("NFT card").resizable().scaledToFill()
                }
            }
        } else {
            Image("NFT card").resizable().scaledToFill()
        }
    }
}
