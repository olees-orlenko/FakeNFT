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
        .task { await viewModel.load() }
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
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(items) { item in
                        NFTCardView(
                            title: item.title,
                            rating: item.rating,
                            priceETH: item.price,
                            imageURL: item.imageURL,
                            isLiked: Binding(
                                get: { viewModel.likedIds.contains(item.id) },
                                set: { _ in }
                            ),
                            isInCart: Binding(
                                get: { viewModel.cartIds.contains(item.id) },
                                set: { _ in }
                            ),
                            onTapLike: {
                                let newValue = !viewModel.likedIds.contains(item.id)
                                Task { await viewModel.setLiked(nftId: item.id, isLiked: newValue) }
                            },
                            onTapCart: {
                                let newValue = !viewModel.cartIds.contains(item.id)
                                Task { await viewModel.setInCart(nftId: item.id, isInCart: newValue) }
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            }
        }
    }
}
