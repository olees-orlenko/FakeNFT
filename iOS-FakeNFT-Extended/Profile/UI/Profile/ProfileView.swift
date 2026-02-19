import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {
    @StateObject private var favoritesStore = ProfileFavoritesViewModel()

    @State private var viewData: ProfileViewData
    @State private var screenState: ScreenState
    @State private var myNFTItems: [MyNFTItem] = []
    @State private var favoriteNFTItems: [FavoriteNFTItem] = []
    @State private var myNFTsScreenState: ScreenState = .loading
    @State private var favoritesScreenState: ScreenState = .loading
    @State private var profileDTO: ProfileDTO?
    @State private var allNFTsByID: [String: Nft] = [:]
    @State private var hasLoaded = false
    @State private var isLikeRequestInFlight = false

    private let profileService: ProfileService
    private let shouldLoadOnAppear: Bool

    init(
        screenState: ScreenState = .content,
        viewData: ProfileViewData = .mock,
        shouldLoadOnAppear: Bool = true,
        profileService: ProfileService = ProfileServiceImpl(networkClient: DefaultNetworkClient())
    ) {
        _screenState = State(initialValue: screenState)
        _viewData = State(initialValue: viewData)
        self.shouldLoadOnAppear = shouldLoadOnAppear
        self.profileService = profileService
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
                                await saveProfile(
                                    name: updatedName,
                                    description: updatedDescription,
                                    site: updatedSite,
                                    avatarURL: updatedAvatarURL
                                )
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
        .task {
            guard shouldLoadOnAppear, !hasLoaded else { return }
            hasLoaded = true
            await loadProfileData()
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
                    Button(NSLocalizedString("Common.cancel", comment: "")) {
                        screenState = .content
                    }
                    .font(.system(size: 17, weight: .regular))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()

                    Button(NSLocalizedString("Common.retry", comment: "")) {
                        Task {
                            await loadProfileData()
                        }
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
            ProfileWebsiteView(url: viewData.websiteURL)
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
                MyNFTsView(
                    items: myNFTItems,
                    favoriteIDs: favoritesStore.favoriteIDs,
                    screenState: $myNFTsScreenState,
                    onRetry: {
                        Task { await loadProfileData() }
                    },
                    onLikeTap: { nftID in
                        Task { await toggleFavorite(nftID: nftID) }
                    }
                )
            } label: {
                ProfileRowView(
                    title: "Мои NFT",
                    count: myNFTItems.count
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                FavoritesNFTsView(
                    items: favoriteNFTItems,
                    screenState: $favoritesScreenState,
                    onRetry: {
                        Task { await loadProfileData() }
                    },
                    onLikeTap: { nftID in
                        Task { await toggleFavorite(nftID: nftID) }
                    }
                )
            } label: {
                ProfileRowView(
                    title: "Избранные NFT",
                    count: favoriteNFTItems.count
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

    private func loadProfileData() async {
        screenState = .loading
        myNFTsScreenState = .loading
        favoritesScreenState = .loading

        do {
            let profile = try await profileService.fetchProfile()
            let nftList = try await profileService.fetchNFTList()
            apply(profile: profile, nftList: nftList)
            screenState = .content
            myNFTsScreenState = .content
            favoritesScreenState = .content
        } catch {
            let message = NSLocalizedString("Profile.error.load", comment: "")
            screenState = .error(message)
            myNFTsScreenState = .error(NSLocalizedString("Profile.MyNFTs.error", comment: ""))
            favoritesScreenState = .error(NSLocalizedString("Profile.Favorites.error", comment: ""))
        }
    }

    private func apply(profile: ProfileDTO, nftList: [Nft]) {
        profileDTO = profile
        allNFTsByID = Dictionary(uniqueKeysWithValues: nftList.map { ($0.id, $0) })

        let favoriteIDs = Set(profile.likes)
        favoritesStore.replace(with: favoriteIDs)

        myNFTItems = profile.nfts
            .compactMap { allNFTsByID[$0] }
            .map(MyNFTItem.init(nft:))

        favoriteNFTItems = profile.likes
            .compactMap { allNFTsByID[$0] }
            .map(FavoriteNFTItem.init(nft:))

        let websiteURL = makeWebsiteURL(from: profile.website) ?? ProfileViewData.mock.websiteURL
        let websiteTitle = profile.website
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")

        viewData = ProfileViewData(
            name: profile.name,
            description: profile.description,
            websiteTitle: websiteTitle,
            websiteURL: websiteURL,
            myNftCount: myNFTItems.count,
            favoriteNftCount: favoriteNFTItems.count,
            avatarURLString: profile.avatar
        )
    }

    private func saveProfile(
        name: String,
        description: String,
        site: String,
        avatarURL: String
    ) async -> Bool {
        guard let currentProfile = profileDTO else { return false }

        let payload = ProfileUpdateDTO(
            name: name,
            description: description,
            avatar: avatarURL,
            website: site,
            likes: Array(favoritesStore.favoriteIDs)
        )

        do {
            let updated = try await profileService.updateProfile(payload)
            apply(profile: updated, nftList: Array(allNFTsByID.values))
            return true
        } catch {
            profileDTO = currentProfile
            return false
        }
    }

    private func toggleFavorite(nftID: String) async {
        guard !isLikeRequestInFlight, let currentProfile = profileDTO else { return }

        isLikeRequestInFlight = true

        let wasFavorite = favoritesStore.isFavorite(id: nftID)
        if wasFavorite {
            favoritesStore.remove(id: nftID)
        } else {
            favoritesStore.insert(id: nftID)
        }

        updateFavoriteItemsFromCache()

        let payload = ProfileUpdateDTO(
            name: currentProfile.name,
            description: currentProfile.description,
            avatar: currentProfile.avatar,
            website: currentProfile.website,
            likes: Array(favoritesStore.favoriteIDs)
        )

        do {
            let updated = try await profileService.updateProfile(payload)
            apply(profile: updated, nftList: Array(allNFTsByID.values))
            myNFTsScreenState = .content
            favoritesScreenState = .content
        } catch {
            if wasFavorite {
                favoritesStore.insert(id: nftID)
            } else {
                favoritesStore.remove(id: nftID)
            }
            updateFavoriteItemsFromCache()
            favoritesScreenState = .error(NSLocalizedString("Profile.Favorites.error", comment: ""))
        }

        isLikeRequestInFlight = false
    }

    private func updateFavoriteItemsFromCache() {
        favoriteNFTItems = favoritesStore.favoriteIDs
            .compactMap { allNFTsByID[$0] }
            .map(FavoriteNFTItem.init(nft:))

        viewData = viewData.updated(
            name: viewData.name,
            description: viewData.description,
            websiteTitle: viewData.websiteTitle,
            websiteURL: viewData.websiteURL,
            avatarURLString: viewData.avatarURLString,
            myNftCount: myNFTItems.count,
            favoriteNftCount: favoriteNFTItems.count
        )
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

#Preview {
    ProfileView(shouldLoadOnAppear: false)
}

#Preview("Loading") {
    ProfileView(screenState: .loading, shouldLoadOnAppear: false)
}

#Preview("Error") {
    ProfileView(screenState: .error("Не удалось загрузить профиль"), shouldLoadOnAppear: false)
}
