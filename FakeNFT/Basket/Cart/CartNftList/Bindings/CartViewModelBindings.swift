//
//  CartViewModelBindings.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 13.10.2023.
//

import Foundation

struct CartViewModelBindings {
    let numberOfNft: ClosureInt
    let priceTotal: ClosureDecimal
    let nftList: ([CartNftInfo]) -> Void
    let isEmptyCartPlaceholderDisplaying: ClosureBool
    let isNetworkAlertDisplaying: ClosureBool
    let isPaymentScreenDisplaying: ClosureBool
}
