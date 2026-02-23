//
//  UserByIdRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 22/02/26.
//

import Foundation

struct UserByIdRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
}
