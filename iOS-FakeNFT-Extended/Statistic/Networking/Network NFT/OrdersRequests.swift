//
//  OrdersRequests.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 24/02/26.
//

import Foundation

struct OrdersRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
}

struct UpdateOrdersRequest: NetworkRequest {
    let id: String
    let orders: OrdersDTO

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }

    var httpMethod: HttpMethod { .put }
    var dto: Encodable? { orders }
}
