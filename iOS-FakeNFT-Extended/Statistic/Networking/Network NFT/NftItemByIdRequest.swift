//
//  NftItemByIdRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 23/02/26.
//

import Foundation

struct NftItemByIdRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
