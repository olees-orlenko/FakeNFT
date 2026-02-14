import SwiftUI
import WebKit

final class ProfileFavoritesStore: ObservableObject {
    @Published private(set) var favoriteNames: Set<String>

    init(initialFavoriteNames: Set<String> = Set(FavoriteNFTItem.defaultFavoriteNames)) {
        self.favoriteNames = initialFavoriteNames
    }

    func isFavorite(name: String) -> Bool {
        favoriteNames.contains(name)
    }

    func toggle(name: String) {
        if favoriteNames.contains(name) {
            favoriteNames.remove(name)
        } else {
            favoriteNames.insert(name)
        }
    }

    func remove(name: String) {
        favoriteNames.remove(name)
    }
}

struct ProfileView: View {
    @StateObject private var favoritesStore = ProfileFavoritesStore()
    @State private var viewData: ProfileViewData
    @State private var screenState: ProfileScreenState

    init(
        screenState: ProfileScreenState = .content,
        viewData: ProfileViewData = .mock
    ) {
        _screenState = State(initialValue: screenState)
        _viewData = State(initialValue: viewData)
    }

    var body: some View {
        NavigationStack {
            Group {
                switch screenState {
                case .loading:
                    loadingStateView
                case .error(let message):
                    ZStack {
                        contentView
                        errorStateView(message: message)
                    }
                case .content:
                    contentView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if case .content = screenState {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            EditProfileView(
                                name: viewData.name,
                                description: viewData.description,
                                site: viewData.websiteTitle,
                                avatarURL: viewData.avatarURLString
                            ) { updatedName, updatedDescription, updatedSite, updatedAvatarURL in
                                viewData.name = updatedName
                                viewData.description = updatedDescription
                                viewData.websiteTitle = updatedSite
                                viewData.avatarURLString = updatedAvatarURL

                                if let url = makeWebsiteURL(from: updatedSite) {
                                    viewData.websiteURL = url
                                }
                            }
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundStyle(Color.primary)
                        }
                        .frame(width: 42, height: 42)
                        .accessibilityLabel("Редактировать профиль")
                    }
                }
            }
        }
        .environmentObject(favoritesStore)
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

    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                descriptionSection
                linkSection
                actionsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
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

    private var headerSection: some View {
        HStack(alignment: .center, spacing: 16) {
            avatarView
            Text(viewData.name)
                .font(.system(size: 22, weight: .bold))
                .kerning(0.35)
                .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                .lineLimit(2)
                .lineSpacing(6)
        }
    }

    private var descriptionSection: some View {
        Text(viewData.description)
            .font(.system(size: 13, weight: .regular))
            .kerning(-0.08)
            .lineSpacing(5)
            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
            .fixedSize(horizontal: false, vertical: true)
    }

    private var linkSection: some View {
        NavigationLink {
            ProfileWebsiteView(
                url: viewData.websiteURL
            )
        } label: {
            Text(viewData.websiteTitle)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.blue)
        }
        .buttonStyle(.plain)
    }

    private var actionsSection: some View {
        VStack(spacing: 8) {
            NavigationLink {
                MyNFTsView()
            } label: {
                ProfileRowView(
                    title: "Мои NFT",
                    count: viewData.myNftCount
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                FavoritesNFTsView()
            } label: {
                ProfileRowView(
                    title: "Избранные NFT",
                    count: favoritesStore.favoriteNames.count
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 16)
    }

    private var avatarView: some View {
        Group {
            if let avatarURL = URL(string: viewData.avatarURLString), !viewData.avatarURLString.isEmpty {
                AsyncImage(url: avatarURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    initialsAvatar
                }
            } else {
                initialsAvatar
            }
        }
        .frame(width: 70, height: 70)
        .clipShape(Circle())
    }

    private var initialsAvatar: some View {
        ZStack {
            Circle()
                .fill(Color(.systemGray5))
            Text(viewData.initials)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(.systemGray))
        }
    }

    private func makeWebsiteURL(from site: String) -> URL? {
        let trimmed = site.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") {
            return URL(string: trimmed)
        }

        return URL(string: "https://\(trimmed)")
    }
}

private struct ProfileRowView: View {
    let title: String
    let count: Int

    var body: some View {
        HStack {
            Text("\(title) (\(count))")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color(.systemGray2))
        }
        .frame(height: 54)
        .padding(.horizontal, 16)
    }
}

struct ProfileViewData {
    var name: String
    var description: String
    var websiteTitle: String
    var websiteURL: URL
    var myNftCount: Int
    var favoriteNftCount: Int
    var avatarURLString: String

    var initials: String {
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }
        return String(initials)
    }

    static let mock = ProfileViewData(
        name: "Joaquin Phoenix",
        description: "Дизайнер из Казани, люблю цифровое искусство и бегать. В моей коллекции уже 100+ NFT, и еще больше — на моем сайте. Открыт к коллаборациям.",
        websiteTitle: "Joaquin Phoenix.com",
        websiteURL: URL(string: "https://practicum.yandex.ru/ios-developer/")!,
        myNftCount: 112,
        favoriteNftCount: 11,
        avatarURLString: ""
    )
}

private struct ProfileWebsiteView: View {
    let url: URL

    var body: some View {
        ProfileWebView(url: url)
            .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ProfileWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }
}

enum ProfileScreenState {
    case loading
    case error(String)
    case content
}

#Preview {
    ProfileView()
}

#Preview("Loading") {
    ProfileView(screenState: .loading)
}

#Preview("Error") {
    ProfileView(screenState: .error("Не удалось загрузить профиль"))
}
