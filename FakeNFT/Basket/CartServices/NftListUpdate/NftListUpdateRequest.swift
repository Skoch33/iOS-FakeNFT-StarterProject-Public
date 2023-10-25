//
//  NftListUpdateRequest.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

struct NftListUpdateRequest: CartNetworkRequest {
    let updatedNftList: CartNftListUpdate
    let servicePath: String = "/orders/1"
    var endpoint: URL?
    var httpMethod: HttpMethod { .put }
    var dto: Encodable? {
        OrderDtoUpdate(nfts: updatedNftList.nfts)
    }

    init(updatedNftList: CartNftListUpdate) {
        self.updatedNftList = updatedNftList
        self.endpoint = URL(string: baseURLString + servicePath)
    }
}
