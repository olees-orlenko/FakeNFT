import SwiftUI

struct StatisticsScreen: View {
    
    struct UserStat: Identifiable {
        let id = UUID()
        let avatarURL: URL?
        let name: String
        let rating: Int
    }
    
    let users: [UserStat]
    var onSortTap: (() -> Void)? = nil
    var onSelectUser: ((UserStat) -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            
            NavigationTitleView(
                title: nil,
                systemImage: "list.bullet",
                buttonPosition: .right,
                titleAlignment: .center,
                onTap: { onSortTap?() }
            )
            
            List {
                ForEach(Array(users.enumerated()), id: \.element.id) { index, user in
                    HStack {
                        Spacer()
                        
                        StatisticsRowView(
                            position: index + 1,
                            avatarURL: user.avatarURL,
                            name: user.name,
                            rating: user.rating
                        )
                        
                        Spacer()
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 6)
                }
            }
            .listStyle(.plain)
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }
}

#Preview {
    let mockUsers: [StatisticsScreen.UserStat] = [
        .init(avatarURL: nil, name: "Alex", rating: 228),
        .init(avatarURL: nil, name: "Mila", rating: 210),
        .init(avatarURL: nil, name: "Sasha", rating: 199),
        .init(avatarURL: nil, name: "Daria", rating: 187),
        .init(avatarURL: nil, name: "Ilya", rating: 176),
        .init(avatarURL: nil, name: "Anya", rating: 165),
        .init(avatarURL: nil, name: "Oleg", rating: 152),
        .init(avatarURL: nil, name: "Nikita", rating: 141),
        .init(avatarURL: nil, name: "Vera", rating: 133),
        .init(avatarURL: nil, name: "Tim", rating: 120)
    ]
    
    StatisticsScreen(users: mockUsers)
}
