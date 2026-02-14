import SwiftUI

struct FavoritesNFTsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var favoritesStore: ProfileFavoritesStore
    private let columns = [
        GridItem(.fixed(168), spacing: 7),
        GridItem(.fixed(168), spacing: 7)
    ]
    @State private var screenState: FavoritesNFTsScreenState

    init(screenState: FavoritesNFTsScreenState = .content) {
        _screenState = State(initialValue: screenState)
    }

    var body: some View {
        Group {
            switch screenState {
            case .loading:
                loadingStateView
            case .error(let message):
                ZStack {
                    contentStateView
                    errorStateView(message: message)
                }
            case .content:
                contentStateView
            }
        }
        .navigationTitle("Избранные NFT")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                }
            }
        }
    }

    private var loadingStateView: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var contentStateView: some View {
        Group {
            if items.isEmpty {
                VStack {
                    Spacer()
                    Text("У Вас ещё нет избранных NFT")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                        ForEach(items) { item in
                            FavoriteNFTCard(item: item) {
                                removeFromFavorites(name: item.name)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
    }

    private func errorStateView(message: String) -> some View {
        ZStack {
            Color.black
                .opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text(message)
                    .font(.system(size: 31.0 / 2, weight: .semibold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)

                Divider()

                HStack(spacing: 0) {
                    Button("Отмена") {
                        screenState = .content
                    }
                    .font(.system(size: 17, weight: .regular))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()

                    Button("Повторить") {
                        screenState = .content
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 44)
            }
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 32)
        }
    }

    private var items: [FavoriteNFTItem] {
        FavoriteNFTItem.catalog.filter { favoritesStore.isFavorite(name: $0.name) }
    }

    private func removeFromFavorites(name: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            favoritesStore.remove(name: name)
        }
    }
}

private struct FavoriteNFTCard: View {
    let item: FavoriteNFTItem
    let onLikeTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            icon

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .lineLimit(1)
                starsView
                Text(item.price)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .lineLimit(1)
            }
        }
        .frame(width: 168, height: 80, alignment: .leading)
    }

    private var icon: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.35), Color.pink.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay {
                    Text(item.name.prefix(1))
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                }

            Button(action: onLikeTap) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#F56B6C")))
                    .padding(4)
            }
            .buttonStyle(.plain)
        }
    }

    private var starsView: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { idx in
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(idx < item.rating ? Color.yellow : Color(uiColor: UIColor.systemGray5))
            }
        }
    }
}

struct FavoriteNFTItem: Identifiable {
    let id: String
    let name: String
    let rating: Int
    let price: String

    static let catalog: [FavoriteNFTItem] = [
        FavoriteNFTItem(id: "1", name: "Archie", rating: 1, price: "1,78 ETH"),
        FavoriteNFTItem(id: "2", name: "Pixi", rating: 3, price: "1,78 ETH"),
        FavoriteNFTItem(id: "3", name: "Melissa", rating: 5, price: "1,78 ETH"),
        FavoriteNFTItem(id: "4", name: "April", rating: 2, price: "1,78 ETH"),
        FavoriteNFTItem(id: "5", name: "Daisy", rating: 1, price: "1,78 ETH"),
        FavoriteNFTItem(id: "6", name: "Lilo", rating: 4, price: "1,78 ETH"),
        FavoriteNFTItem(id: "7", name: "Spring", rating: 3, price: "1,78 ETH")
    ]

    static let defaultFavoriteNames = [
        "Archie",
        "Pixi",
        "Melissa",
        "April",
        "Daisy",
        "Lilo"
    ]
}

enum FavoritesNFTsScreenState {
    case loading
    case error(String)
    case content
}

#Preview {
    NavigationStack {
        FavoritesNFTsView()
    }
    .environmentObject(ProfileFavoritesStore())
}

#Preview("Empty") {
    let store = ProfileFavoritesStore(initialFavoriteNames: Set<String>())
    NavigationStack {
        FavoritesNFTsView()
    }
    .environmentObject(store)
}

#Preview("Loading") {
    NavigationStack {
        FavoritesNFTsView(screenState: .loading)
    }
    .environmentObject(ProfileFavoritesStore())
}

#Preview("Error") {
    NavigationStack {
        FavoritesNFTsView(screenState: .error("Не удалось загрузить избранные NFT"))
    }
    .environmentObject(ProfileFavoritesStore())
}
