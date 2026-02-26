import SwiftUI

enum StatisticsScreenState {
    case loading
    case error(String)
    case content([StatisticsScreen.UserStat])
}

enum StatisticsSortType: String, CaseIterable {
    case byName = "По имени"
    case byRating = "По рейтингу"
}

final class StatisticsViewModel: ObservableObject {
    @Published var state: StatisticsScreenState = .loading
    @Published var sortType: StatisticsSortType = .byRating
    @Published var isSortSheetPresented = false

    private let sortKey = "StatisticsSortType"
    private var allUsers: [StatisticsScreen.UserStat] = []

    init() {
        loadSortType()
        loadUsers()
    }

    func loadUsers() {
        state = .loading
        // Здесь должен быть реальный сетевой запрос, сейчас — мок
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let users = [
                StatisticsScreen.UserStat(avatarURL: nil, name: "Alex", rating: 228),
                StatisticsScreen.UserStat(avatarURL: nil, name: "Mila", rating: 210),
                StatisticsScreen.UserStat(avatarURL: nil, name: "Sasha", rating: 199),
                StatisticsScreen.UserStat(avatarURL: nil, name: "Daria", rating: 187),
                StatisticsScreen.UserStat(avatarURL: nil, name: "Ilya", rating: 176),
                StatisticsScreen.UserStat(avatarURL: nil, name: "Anya", rating: 165),
                StatisticsScreen.UserStat(avatarURL: nil, name: "Oleg", rating: 152),
                StatisticsScreen.UserStat(avatarURL: nil, name: "Nikita", rating: 141),
                StatisticsScreen.UserStat(avatarURL: nil, name: "Vera", rating: 133),
                StatisticsScreen.UserStat(avatarURL: nil, name: "Tim", rating: 120)
            ]
            DispatchQueue.main.async {
                self.allUsers = users
                self.applySort()
            }
        }
    }

    func retry() {
        loadUsers()
    }

    func showSortSheet() {
        isSortSheetPresented = true
    }

    func selectSort(_ type: StatisticsSortType) {
        sortType = type
        saveSortType()
        applySort()
        isSortSheetPresented = false
    }

    private func applySort() {
        let sorted: [StatisticsScreen.UserStat]
        switch sortType {
        case .byName:
            sorted = allUsers.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .byRating:
            sorted = allUsers.sorted { $0.rating > $1.rating }
        }
        state = .content(sorted)
    }

    private func saveSortType() {
        UserDefaults.standard.set(sortType.rawValue, forKey: sortKey)
    }

    private func loadSortType() {
        if let raw = UserDefaults.standard.string(forKey: sortKey),
           let type = StatisticsSortType(rawValue: raw) {
            sortType = type
        }
    }
}
