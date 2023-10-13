//
//  CartViewModelBindings.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 13.10.2023.
//

import Foundation

struct CartViewModelBindings {
    let numberOfNft: (Int) -> Void
    let priceTotal: (Decimal) -> Void
    let nftList: ([CartNftInfo]) -> Void
    let isEmptyCartPlaceholderDisplaying: (Bool) -> Void
}
