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
                            FavoriteNFTCardView(item: item) {
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
