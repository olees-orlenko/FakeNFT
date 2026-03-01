import SwiftUI

// MARK: - FavoritesNFTsView

struct FavoritesNFTsView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    let items: [FavoriteNFTItem]
    @Binding var screenState: ScreenState
    let onRetry: () -> Void
    let onLikeTap: (String) -> Void
    private let columns = [
        GridItem(.fixed(168), spacing: 7),
        GridItem(.fixed(168), spacing: 7)
    ]

    // MARK: - Body

    var body: some View {
        content
            .navigationTitle(NSLocalizedString("Profile.Favorites.title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
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

    // MARK: - Subviews

    private var content: some View {
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
                    Text(NSLocalizedString("Profile.Favorites.empty", comment: ""))
                        .font(Font(UIFont.bodyBold))
                        .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                        ForEach(items) { item in
                            FavoriteNFTCardView(item: item) {
                                onLikeTap(item.id)
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
                    .font(Font(UIFont.bodyBold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)

                Divider()

                HStack(spacing: 0) {
                    Button(NSLocalizedString("Common.cancel", comment: "")) {
                        screenState = .content
                    }
                    .font(Font(UIFont.bodyRegular))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()

                    Button(NSLocalizedString("Common.retry", comment: "")) {
                        onRetry()
                    }
                    .font(Font(UIFont.bodyBold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 44)
            }
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesNFTsView(
            items: FavoriteNFTItem.catalog,
            screenState: .constant(.content),
            onRetry: {},
            onLikeTap: { _ in }
        )
    }
}

#Preview("Empty") {
    NavigationStack {
        FavoritesNFTsView(
            items: [],
            screenState: .constant(.content),
            onRetry: {},
            onLikeTap: { _ in }
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        FavoritesNFTsView(
            items: [],
            screenState: .constant(.loading),
            onRetry: {},
            onLikeTap: { _ in }
        )
    }
}

#Preview("Error") {
    NavigationStack {
        FavoritesNFTsView(
            items: FavoriteNFTItem.catalog,
            screenState: .constant(.error(NSLocalizedString("Profile.Favorites.error", comment: ""))),
            onRetry: {},
            onLikeTap: { _ in }
        )
    }
}
