import SwiftUI
import Foundation

struct StatisticsFlowView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var path: [StatisticsRoute] = []
    @State private var safariURL: IdentifiableURL? = nil

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                switch viewModel.state {
                case .loading:
                    VStack {
                        ProgressView().padding()
                        Spacer()
                    }

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
                            path.append(.userCard(userId: user.id))
                        }
                    )
                }
            }
            .navigationDestination(for: StatisticsRoute.self) { route in
                switch route {
                case .userCard(let userId):
                    userCardDestination(userId: userId)

                case .nftCollection(let userId):
                    nftCollectionDestination(userId: userId)
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

    // MARK: - Destinations

    @ViewBuilder
    private func userCardDestination(userId: String) -> some View {
        if case .content(let users) = viewModel.state,
           let user = users.first(where: { $0.id == userId }) {

            let nftIds = viewModel.userNftIds(for: user)
            let nftCount = nftIds.count

            UserCardScreen(
                avatarURL: user.avatarURL,
                name: user.name,
                about: viewModel.aboutText(for: user),
                nftCount: nftCount,
                onBack: { popIfPossible() },
                onOpenWebsite: {
                    if let url = viewModel.websiteURL(for: user) {
                        safariURL = IdentifiableURL(url: url)
                    }
                },
                onNext: {
                    path.append(.nftCollection(userId: userId))
                }
            )

        } else {
            VStack(spacing: 12) {
                ProgressView()
                Text("Загрузка...")
                    .foregroundColor(.secondary)
                Button("Назад") { popIfPossible() }
            }
        }
    }

    @ViewBuilder
    private func nftCollectionDestination(userId: String) -> some View {
        if case .content(let users) = viewModel.state,
           let user = users.first(where: { $0.id == userId }) {

            let nftIds = viewModel.userNftIds(for: user)

            NFTCollectionScreen(
                userId: userId,
                nftIds: nftIds,
                onBack: { popIfPossible() }
            )

        } else {
            VStack(spacing: 12) {
                ProgressView()
                Text("Загрузка...")
                    .foregroundColor(.secondary)
                Button("Назад") { popIfPossible() }
            }
        }
    }

    // MARK: - Helpers

    private func popIfPossible() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

#Preview {
    StatisticsFlowView()
}
