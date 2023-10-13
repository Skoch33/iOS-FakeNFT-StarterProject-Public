//
//  CartCellViewModelBindings.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 13.10.2023.
//

import Foundation

struct CartCellViewModelBindings {
    let rating: (Int) -> Void
    let price: (Decimal) -> Void
    let name: (String) -> Void
    let imageURL: (URL?) -> Void
}
