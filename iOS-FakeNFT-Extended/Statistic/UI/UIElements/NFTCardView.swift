import SwiftUI

struct NFTCardView: View {
    
    let title: String
    let rating: Int
    let priceETH: String
    
    @Binding var isLiked: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .topTrailing) {
                Image("NFT card")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
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
}

#Preview {
    VStack(spacing: 20) {
        NFTCardView(
            title: "Stella",
            rating: 4,
            priceETH: "1.78",
            isLiked: .constant(false)
        )
    }
}
