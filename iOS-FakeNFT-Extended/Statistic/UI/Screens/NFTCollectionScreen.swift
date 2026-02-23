import SwiftUI
import Foundation

struct NFTCollectionScreen: View {

    struct NFTItem: Identifiable {
        let id: String
        let title: String
        let rating: Int
        let price: String
        let imageURL: URL?
    }

    let userId: String
    let nftIds: [String]
    var onBack: (() -> Void)? = nil

    @StateObject private var viewModel: NFTCollectionViewModel
    @State private var likedItems: Set<String> = []

    private let columns = [
        GridItem(.fixed(108), spacing: 12),
        GridItem(.fixed(108), spacing: 12),
        GridItem(.fixed(108), spacing: 0)
    ]

    init(
        userId: String = "",
        nftIds: [String],
        service: NftItemsService = NftItemsServiceImpl(),
        onBack: (() -> Void)? = nil
    ) {
        self.userId = userId
        self.nftIds = nftIds
        self.onBack = onBack
        _viewModel = StateObject(wrappedValue: NFTCollectionViewModel(nftIds: nftIds, service: service))
    }

    var body: some View {
        VStack(spacing: 26) {

            NavigationTitleView(
                title: "Коллекция NFT",
                systemImage: "chevron.left",
                buttonPosition: .left,
                titleAlignment: .center,
                onTap: { onBack?() }
            )

            content
        }
        .padding(.top, 8)
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
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
                Button("Повторить") {
                    Task { await viewModel.load() }
                }
            }
            .padding(.horizontal, 16)

        case .content(let items):
            if items.isEmpty {
                VStack(spacing: 12) {
                    Text("Коллекция пуста")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(items) { item in
                            NFTCardView(
                                title: item.title,
                                rating: item.rating,
                                priceETH: item.price,
                                imageURL: item.imageURL,
                                isLiked: Binding(
                                    get: { likedItems.contains(item.id) },
                                    set: { isLiked in
                                        if isLiked { likedItems.insert(item.id) }
                                        else { likedItems.remove(item.id) }
                                    }
                                )
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

#Preview {
    NFTCollectionScreen(
        userId: "3",
        nftIds: ["1", "2", "3"]
    )
}
