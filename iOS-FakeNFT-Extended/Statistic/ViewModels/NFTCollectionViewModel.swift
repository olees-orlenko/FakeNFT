import Foundation

@MainActor
final class NFTCollectionViewModel: ObservableObject {

    enum ScreenState {
        case loading
        case error(String)
        case content([NFTCollectionScreen.NFTItem])
    }

    @Published private(set) var state: ScreenState = .loading
    @Published private(set) var likedIds: Set<String> = []
    @Published private(set) var cartIds: Set<String> = []

    private let nftIds: [String]
    private let service: NftItemsService
    private let likesCartService: LikesAndCartService
    private let myProfileId = "1"
    private let myOrdersId  = "1"

    init(
        nftIds: [String],
        service: NftItemsService = NftItemsServiceImpl(),
        likesCartService: LikesAndCartService = LikesAndCartServiceImpl()
    ) {
        self.nftIds = nftIds
        self.service = service
        self.likesCartService = likesCartService
    }

    func load() async {
        state = .loading

        do {
            async let profile = likesCartService.loadMyProfile(profileId: myProfileId)
            async let orders  = likesCartService.loadMyOrders(ordersId: myOrdersId)

            let (p, o) = try await (profile, orders)
            likedIds = Set(p.likes)
            cartIds  = Set(o.nfts)
            guard !nftIds.isEmpty else {
                state = .content([])
                return
            }

            let dtos = try await service.loadNftItems(ids: nftIds)
            let items = dtos.map { dto in
                NFTCollectionScreen.NFTItem(
                    id: dto.id,
                    title: dto.name,
                    rating: dto.rating,
                    price: Self.priceString(dto.price),
                    imageURL: dto.images.first
                )
            }

            state = .content(items)

        } catch {
            state = .error(userMessage(for: error))
        }
    }

    func setLiked(nftId: String, isLiked: Bool) async {
        let old = likedIds

        if isLiked { likedIds.insert(nftId) }
        else { likedIds.remove(nftId) }

        do {
            let updated = try await likesCartService.saveMyLikes(profileId: myProfileId, likes: Array(likedIds))
            likedIds = Set(updated.likes)
        } catch {
            likedIds = old
            print("❌ Like update failed:", error.localizedDescription)
        }
    }

    func setInCart(nftId: String, isInCart: Bool) async {
        let old = cartIds

        if isInCart { cartIds.insert(nftId) }
        else { cartIds.remove(nftId) }

        do {
            let updated = try await likesCartService.saveMyCart(ordersId: myOrdersId, nftIds: Array(cartIds))
            cartIds = Set(updated.nfts)
        } catch {
            cartIds = old
            print("❌ Cart update failed:", error.localizedDescription)
        }
    }

    // MARK: - Helpers (твои же)

    private static func priceString(_ value: Double) -> String {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.decimalSeparator = "."
        return f.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }

    private func userMessage(for error: Error) -> String {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            return "Нет подключения к интернету"
        }
        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let code):
                return "Ошибка сервера (\(code))"
            case .parsingError:
                return "Не удалось прочитать данные"
            case .urlRequestError(let e):
                return "Сетевая ошибка: \(e.localizedDescription)"
            default:
                return "Не удалось загрузить данные"
            }
        }
        return "Не удалось загрузить данные"
    }
}
