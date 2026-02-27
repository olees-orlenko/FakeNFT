import Foundation

// MARK: - NFTListRequest

struct NFTListRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }
}
