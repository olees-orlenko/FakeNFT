import SwiftUI

struct StatisticsRowView: View {
    
    let position: Int
    let avatarURL: URL?
    let name: String
    let rating: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(position)")
                .font(.system(size: 15, weight: .regular))
                .frame(width: 27, alignment: .leading)
                .foregroundColor(.primary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.segmentInactive))
                
                HStack(spacing: 12) {
                    avatarView
                    Text(name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Рейтинг
                    Text("\(rating)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 12)
            }
            .frame(width: 308, height: 80)
        }
        .frame(width: 343, height: 80)
    }
    
    private var avatarView: some View {
        Group {
            if let avatarURL {
                AsyncImage(url: avatarURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image("Userpick")
                        .resizable()
                        .scaledToFill()
                }
            } else {
                Image("Userpick")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 28, height: 28)
        .clipShape(Circle())
    }
}

#Preview {
    VStack(spacing: 12) {
        StatisticsRowView(position: 1, avatarURL: nil, name: "Alex", rating: 228)
        StatisticsRowView(position: 2, avatarURL: URL(string: "https://i.pravatar.cc/150"), name: "Mila", rating: 210)
    }
    .padding()
}
