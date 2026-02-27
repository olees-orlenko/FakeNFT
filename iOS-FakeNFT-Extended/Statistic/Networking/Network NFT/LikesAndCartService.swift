import Foundation

protocol LikesAndCartService {
    func loadMyProfile(profileId: String) async throws -> StatisticUserProfileDTO
    func saveMyLikes(profileId: String, likes: [String]) async throws -> StatisticUserProfileDTO

    func loadMyOrders(ordersId: String) async throws -> OrdersDTO
    func saveMyCart(ordersId: String, nftIds: [String]) async throws -> OrdersDTO
}

actor LikesAndCartServiceImpl: LikesAndCartService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    // MARK: - Profile

    func loadMyProfile(profileId: String) async throws -> StatisticUserProfileDTO {
        print("📥 loadMyProfile START id =", profileId)

        let req = StatisticProfileRequest(id: profileId)
        let dto: StatisticUserProfileDTO = try await networkClient.send(request: req)

        print("📥 loadMyProfile SUCCESS dto.id =", dto.id)
        print("📥 loadMyProfile likes.count =", dto.likes.count)

        return dto
    }

    func saveMyLikes(profileId: String, likes: [String]) async throws -> StatisticUserProfileDTO {
        print("🧩 saveMyLikes START")

        var profile = try await loadMyProfile(profileId: profileId)
        profile.likes = likes

        let request = StatisticUpdateProfileRequest(id: profileId, profile: profile)

        print("🧩 saveMyLikes:")
        print("  profileId param =", profileId)
        print("  profile.dto.id  =", profile.id)
        print("  endpoint PUT    =", request.endpoint?.absoluteString ?? "nil")
        print("  likes.count     =", likes.count)

        let updated: StatisticUserProfileDTO = try await networkClient.send(request: request)

        print("✅ saveMyLikes SUCCESS updated.likes.count =", updated.likes.count)

        return updated
    }

    // MARK: - Orders

    func loadMyOrders(ordersId: String) async throws -> OrdersDTO {
        print("📥 loadMyOrders START id =", ordersId)

        let req = OrdersRequest(id: ordersId)
        let dto: OrdersDTO = try await networkClient.send(request: req)

        print("📥 loadMyOrders SUCCESS dto.id =", dto.id)
        print("📥 loadMyOrders nfts.count =", dto.nfts.count)

        return dto
    }

    func saveMyCart(ordersId: String, nftIds: [String]) async throws -> OrdersDTO {
        print("🧩 saveMyCart START")

        var orders = try await loadMyOrders(ordersId: ordersId)
        orders.nfts = nftIds

        let request = UpdateOrdersRequest(id: ordersId, orders: orders)

        print("🧩 saveMyCart:")
        print("  ordersId param =", ordersId)
        print("  orders.dto.id  =", orders.id)
        print("  endpoint PUT   =", request.endpoint?.absoluteString ?? "nil")
        print("  nfts.count     =", nftIds.count)

        let updated: OrdersDTO = try await networkClient.send(request: request)

        print("✅ saveMyCart SUCCESS updated.nfts.count =", updated.nfts.count)

        return updated
    }
}
