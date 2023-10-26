//
//  CartCurrencyList.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

struct CartCurrencyList {
    let currencyList: [CartCurrency]

    init(dto: [CurrencyDto]) {
        self.currencyList = dto.map { CartCurrency(dto: $0) }
    }
}
