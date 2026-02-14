import SwiftUI

struct NFTCardView: View {
    
    let title: String
    let rating: Int
    let priceETH: String
    
    @Binding var isLiked: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            // Верхняя картинка + Like
            ZStack(alignment: .topTrailing) {
                Image("NFT card")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                LikeButton(isLiked: $isLiked)
                    .padding(9)
            }
            
            // Рейтинг
            RatingView(rating: rating)
                .frame(height: 12)
            
            // Нижний блок: название+цена слева, корзина справа
            HStack(spacing: 0) {
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("\(priceETH) ETH")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                // контейнер текста (фиксируем, как ты хотел)
                .frame(width: 68, height: 40, alignment: .leading)
                
                Spacer(minLength: 0)
                
                Image("Cart")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.black)
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .frame(width: 108, height: 40)
        }
        .frame(width: 108, height: 172)
    }
}
#Preview {
    NFTCardView(
        title: "Stella",
        rating: 4,
        priceETH: "1.78",
        isLiked: .constant(false)
    )
    .padding()
}
