//
//  CartPaymentRequest.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

struct CartPaymentRequest: CartNetworkRequest {
    var endpoint: URL?
    var servicePath: String = "/orders/1/payment"

    init(forCurrency id: String) {
        self.endpoint = URL(string: baseURLString + servicePath + "/\(id)")
    }
}
