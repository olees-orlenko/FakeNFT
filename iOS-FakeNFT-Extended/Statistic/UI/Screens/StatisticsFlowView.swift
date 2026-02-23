import SwiftUI

struct StatisticsFlowView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var path: [StatisticsRoute] = []
    @State private var safariURL: IdentifiableURL? = nil

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch viewModel.state {
                case .loading:
                    VStack { ProgressView().padding(); Spacer() }

                case .error(let message):
                    VStack(spacing: 12) {
                        Text("Ошибка: \(message)")
                            .foregroundColor(.red)
                        Button("Повторить") { viewModel.retry() }
                    }

                case .content(let users):
                    StatisticsScreen(
                        users: users,
                        onSortTap: { viewModel.showSortSheet() },
                        onSelectUser: { user in
                            // пока нет реального userId — используем name как id
                            path.append(.userCard(userId: user.name))
                        }
                    )
                }
            }
            .navigationDestination(for: StatisticsRoute.self) { route in
                switch route {

                case .userCard(let userId):
                    UserCardScreen(
                        avatarURL: nil,
                        name: userId,
                        about: mockAbout(for: userId),
                        onBack: { popIfPossible() },
                        onOpenWebsite: {
                            safariURL = IdentifiableURL(url: mockWebsite(for: userId))
                        },
                        onNext: {
                            path.append(.nftCollection(userId: userId))
                        }
                    )

                case .nftCollection(let userId):
                    NFTCollectionScreen(
                        userId: userId,
                        items: mockNFTItems(for: userId),
                        onBack: { popIfPossible() }
                    )
                }
            }
            .sheet(item: $safariURL) { item in
                SafariView(url: item.url)
            }
            .sheet(isPresented: $viewModel.isSortSheetPresented) {
                StatisticsSortSheet(
                    isPresented: $viewModel.isSortSheetPresented,
                    selected: viewModel.sortType,
                    onSelect: viewModel.selectSort
                )
            }
        }
    }

    // MARK: - Helpers

    private func popIfPossible() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    private func mockWebsite(for userId: String) -> URL {
        URL(string: "https://example.com")!
    }

    private func mockAbout(for userId: String) -> String {
        "Пользователь \(userId). Описание будет приходить из API на этапе 3/3."
    }

    private func mockNFTItems(for userId: String) -> [NFTCollectionScreen.NFTItem] {
        [
            .init(title: "Stella", rating: 4, price: "1.78"),
            .init(title: "Galaxy", rating: 5, price: "2.10"),
            .init(title: "Ocean", rating: 3, price: "0.98"),
            .init(title: "Neon", rating: 5, price: "3.45"),
            .init(title: "Dream", rating: 2, price: "1.12")
        ]
    }
}
struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

#Preview {
    StatisticsFlowView()
}
