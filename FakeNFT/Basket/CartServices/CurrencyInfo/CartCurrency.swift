//
//  CartCurrency.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

struct CartCurrency {
    let title: String
    let name: String
    let id: String
    var imageURL: URL?

    init(dto: CurrencyDto) {
        self.title = dto.title
        self.name = dto.name
        self.id = dto.id
        self.imageURL = URL(string: dto.image)
    }
}
