//
//  UpdateOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 23.02.26.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    let nfts: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders.1")
    }

    var httpMethod: HttpMethod { .put }

    var dto: Encodable {
        ["nfts": nfts]
    }
}
