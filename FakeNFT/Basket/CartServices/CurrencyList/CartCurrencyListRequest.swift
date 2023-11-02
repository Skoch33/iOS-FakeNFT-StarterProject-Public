//
//  CartCurrencyListRequest.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

struct CartCurrencyListRequest: CartNetworkRequest {
    var endpoint: URL?
    var servicePath: String = "/currencies"

    init() {
        self.endpoint = URL(string: baseURLString + servicePath)
    }
}
