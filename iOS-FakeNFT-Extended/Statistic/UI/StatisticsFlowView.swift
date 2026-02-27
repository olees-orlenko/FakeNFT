import SwiftUI

struct StatisticsFlowView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var path: [StatisticsRoute] = []
    @State private var safariURL: URL? = nil

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch viewModel.state {
                case .loading:
                    VStack { ProgressView().padding(); Spacer() }
                case .error(let message):
                    VStack {
                        Text("Ошибка: \(message)").foregroundColor(.red)
                        Button("Повторить") { viewModel.retry() }
                    }
                case .content(let users):
                    StatisticsScreen(
                        users: users,
                        onSortTap: { viewModel.showSortSheet() },
                        onSelectUser: { user in
                            path.append(.userCard(userId: user.name))
                        }
                    )
                }
            }
            .navigationDestination(for: StatisticsRoute.self) { route in
                switch route {
                case .userCard(let userId):
                    UserCardScreen(
                        userId: userId,
                        onBack: { path.removeLast() },
                        onOpenSite: { url in safariURL = url },
                        onShowNFT: { path.append(.nftCollection(userId: userId)) }
                    )
                case .nftCollection(let userId):
                    NFTCollectionScreen(
                        userId: userId,
                        onBack: { path.removeLast() }
                    )
                }
            }
            .sheet(item: $safariURL) { url in
                SafariView(url: url)
            }
            .overlay(
                StatisticsSortSheet(
                    isPresented: $viewModel.isSortSheetPresented,
                    selected: viewModel.sortType,
                    onSelect: viewModel.selectSort
                )
            )
        }
    }
}
