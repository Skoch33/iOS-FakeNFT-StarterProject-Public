//
//  CartNftList.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

import Foundation

struct CartNftList {
    let ids: [String]

    init(dto: OrderDto) {
        self.ids = dto.nfts
    }
}
