//
//  CartSettingsStorage.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 12.10.2023.
//

import Foundation

protocol CartSettingsStorageProtocol {
    var cartSortOrder: CartSortOrder { get set }
}

struct DefaultCartSettingsStorage: CartSettingsStorageProtocol {
    var cartSortOrder: CartSortOrder {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: dataKey)
            return CartSortOrder(rawValue: rawValue) ?? CartSortOrder.defaultOrder
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: dataKey)
        }
    }
    private let dataKey = "CartSortOrder"
}
