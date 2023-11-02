//
//  CartNetworkRequest.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

protocol CartNetworkRequest: NetworkRequest {
    var baseURLString: String { get }
    var servicePath: String { get }
}

extension CartNetworkRequest {
    var baseURLString: String { "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1" }
}
