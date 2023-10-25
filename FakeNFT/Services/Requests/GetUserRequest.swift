//
//  UsersRequest.swift
//  FakeNFT
//

import Foundation

struct GetUserRequest: NetworkRequest {
    private let baseURL: String = "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/users"

    var endpoint: URL? {
        return URL(string: baseURL)
    }

    var httpMethod: HttpMethod {
        return .get
    }
}
