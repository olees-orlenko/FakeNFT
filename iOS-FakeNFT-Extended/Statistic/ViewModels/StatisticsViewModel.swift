import SwiftUI
import Foundation

enum StatisticsScreenState {
    case loading
    case error(String)
    case content([StatisticsScreen.UserStat])
}

enum StatisticsSortType: String, CaseIterable {
    case byName = "По имени"
    case byRating = "По рейтингу"
}

@MainActor
final class StatisticsViewModel: ObservableObject {

    @Published var state: StatisticsScreenState = .loading
    @Published var sortType: StatisticsSortType = .byRating
    @Published var isSortSheetPresented = false

    private let sortKey = "StatisticsSortType"
    private let usersService: UsersService

    private var allUsers: [UserDTO] = []

    private var page: Int = 0
    private let size: Int = 25
    private var isLoading: Bool = false

    init(usersService: UsersService = UsersServiceImpl()) {
        self.usersService = usersService
        loadSortType()

        Task { await loadUsersInitial() }
    }

    func retry() {
        Task { await loadUsersInitial() }
    }

    func showSortSheet() {
        isSortSheetPresented = true
    }

    func selectSort(_ type: StatisticsSortType) {
        sortType = type
        saveSortType()
        applySortAndPublish()
        isSortSheetPresented = false
    }

    // MARK: - Helpers for next screens

    func websiteURL(for user: StatisticsScreen.UserStat) -> URL? {
        guard let dto = allUsers.first(where: { $0.stableId == user.id }),
              let website = dto.website,
              let url = URL(string: website) else { return nil }
        return url
    }

    func aboutText(for user: StatisticsScreen.UserStat) -> String {
        guard let dto = allUsers.first(where: { $0.stableId == user.id }) else { return "" }
        return dto.description
    }

    func userNftIds(for user: StatisticsScreen.UserStat) -> [String] {
        guard let dto = allUsers.first(where: { $0.stableId == user.id }) else { return [] }
        return dto.nfts
    }

    // MARK: - Loading

    private func loadUsersInitial() async {
        guard !isLoading else { return }
        isLoading = true

        state = .loading
        page = 0
        allUsers = []

        do {
            let users = try await loadUsersWithRetry()
            allUsers = users
            applySortAndPublish()
        } catch {
            state = .error(userMessage(for: error))
        }

        isLoading = false
    }

    private func loadUsersWithRetry() async throws -> [UserDTO] {
        do {
            return try await requestUsers()
        } catch let error as NetworkClientError {
            if case .httpStatusCode(502) = error {
                print("⚠️ Retry after 502...")
                try await Task.sleep(nanoseconds: 700_000_000)
                return try await requestUsers()
            }
            throw error
        }
    }

    private func requestUsers() async throws -> [UserDTO] {
        let sortBy: String? = nil
        return try await usersService.loadUsers(page: page, size: size, sortBy: sortBy)
    }

    // MARK: - Mapping + Sorting

    private func applySortAndPublish() {
        let mapped = allUsers.map { StatisticsScreen.UserStat(dto: $0) }

        let sorted: [StatisticsScreen.UserStat]
        switch sortType {
        case .byName:
            sorted = mapped.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .byRating:
            sorted = mapped.sorted { $0.rating > $1.rating }
        }

        state = .content(sorted)
    }

    // MARK: - Errors

    private func userMessage(for error: Error) -> String {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            return "Нет подключения к интернету"
        }

        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let code):
                if code == 502 { return "Сервер временно недоступен. Попробуйте ещё раз." }
                return "Ошибка сервера (\(code))"
            case .parsingError:
                return "Не удалось прочитать данные"
            case .urlRequestError(let e):
                return "Сетевая ошибка: \(e.localizedDescription)"
            default:
                return "Не удалось загрузить данные"
            }
        }

        return "Не удалось загрузить данные"
    }

    // MARK: - Persistence

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
