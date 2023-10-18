//
//  CartCellViewModelBindings.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 13.10.2023.
//

import Foundation

struct CartCellViewModelBindings {
    let rating: ClosureInt
    let price: ClosureDecimal
    let name: ClosureString
    let imageURL: (URL?) -> Void
}
