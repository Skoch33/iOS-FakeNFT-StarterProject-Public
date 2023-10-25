//
//  NftListRequest.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

import Foundation

struct NftListRequest: CartNetworkRequest {
    var endpoint: URL?
    var servicePath: String = "/orders/1"

    init() {
        self.endpoint = URL(string: baseURLString + servicePath)
    }
}
