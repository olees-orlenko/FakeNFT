//
//  UsersRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 22/02/26.
//

import Foundation

struct UsersRequest: NetworkRequest {
    let page: Int
    let size: Int
    let sortBy: String?

    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/users")
        var items: [URLQueryItem] = [
            .init(name: "page", value: String(page)),
            .init(name: "size", value: String(size))
        ]
        if let sortBy, !sortBy.isEmpty {
            items.append(.init(name: "sortBy", value: sortBy))
        }
        components?.queryItems = items
        return components?.url
    }
}
