//
//  CartCurrencyRequest.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

struct CartCurrencyRequest: CartNetworkRequest {
    var endpoint: URL?
    var servicePath: String = "/currencies"

    init(id: String) {
        self.endpoint = URL(string: baseURLString + servicePath + "/\(id)")
    }
}
