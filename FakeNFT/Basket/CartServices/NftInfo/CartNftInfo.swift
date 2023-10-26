//
//  NftInfo.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

import Foundation

struct CartNftInfo {
    let name: String
    let imageURLString: String?
    let rating: Int
    let price: Decimal
    let id: String

    init(dto: NftInfoDto) {
        self.name = dto.name
        self.imageURLString = dto.images.first
        self.rating = dto.rating
        self.price = dto.price
        self.id = dto.id
    }
}
