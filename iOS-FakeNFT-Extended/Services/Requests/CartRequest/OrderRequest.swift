//
//  OrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 23.02.26.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
