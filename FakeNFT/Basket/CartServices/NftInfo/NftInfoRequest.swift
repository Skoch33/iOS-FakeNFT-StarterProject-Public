//
//  NftInfoRequest.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

import Foundation

struct NFTInfoRequest: CartNetworkRequest {
    var endpoint: URL?
    var servicePath: String = "/nft"

    init(id: String) {
        self.endpoint = URL(string: baseURLString + servicePath + "/\(id)")
    }
}
