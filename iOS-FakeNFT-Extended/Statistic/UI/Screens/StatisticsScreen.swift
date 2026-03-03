import SwiftUI
import Foundation

struct StatisticsScreen: View {

    struct UserStat: Identifiable, Hashable {
        let id: String
        let avatarURL: URL?
        let name: String
        let rating: Int

        init(id: String, avatarURL: URL?, name: String, rating: Int) {
            self.id = id
            self.avatarURL = avatarURL
            self.name = name
            self.rating = rating
        }

        init(dto: UserDTO) {
            self.id = dto.stableId
            self.avatarURL = dto.avatar.flatMap(URL.init(string:))
            self.name = dto.name
            self.rating = dto.rating
        }
    }

    let users: [UserStat]
    var onSelectUser: ((UserStat) -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {

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
                    .contentShape(Rectangle())
                    .onTapGesture { onSelectUser?(user) }
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
        .init(id: "1", avatarURL: nil, name: "Alex", rating: 228),
        .init(id: "2", avatarURL: nil, name: "Mila", rating: 210),
        .init(id: "3", avatarURL: nil, name: "Sasha", rating: 199),
        .init(id: "4", avatarURL: nil, name: "Daria", rating: 187),
        .init(id: "5", avatarURL: nil, name: "Ilya", rating: 176),
        .init(id: "6", avatarURL: nil, name: "Anya", rating: 165),
        .init(id: "7", avatarURL: nil, name: "Oleg", rating: 152),
        .init(id: "8", avatarURL: nil, name: "Nikita", rating: 141),
        .init(id: "9", avatarURL: nil, name: "Vera", rating: 133),
        .init(id: "10", avatarURL: nil, name: "Tim", rating: 120)
    ]

    StatisticsScreen(users: mockUsers)
}
