//
//  CurrencyCellViewModelBindings.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 22.10.2023.
//

import Foundation

struct CurrencyCellViewModelBindings {
    let imageURL: (URL?) -> Void
    let currencyName: ClosureString
    let currencyCode: ClosureString
}
