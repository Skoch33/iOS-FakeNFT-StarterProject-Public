//
//  File.swift
//  FakeNFT
//

import Foundation

struct GetNFTRequest:  NetworkRequest {
    let id: String
    private let baseURL: String = "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/nft/"

    var endpoint: URL? {
        return URL(string: "\(baseURL)\(id)")
    }

    var httpMethod: HttpMethod {
        return .get
    }
}
