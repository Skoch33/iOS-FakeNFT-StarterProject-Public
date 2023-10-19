//
//  CartSortOrder.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 12.10.2023.
//

import Foundation

enum CartSortOrder: Int {
    case byName, byRating, byPrice

    static let defaultOrder: CartSortOrder = .byName
}
