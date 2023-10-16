//
//  CartCurrencyDataProvider.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

protocol CartCurrencyDataProviderProtocol {
    var numberOfCurrencies: Int { get }
    var currencyList: [CartCurrency] { get }
    func getCurrencyList()
}

final class CartCurrencyDataProvider: CartCurrencyDataProviderProtocol {
    var cartCurrencyListDidChangeNotification: Notification.Name {
        Notification.Name(rawValue: "cartCurrencyListDidChangeNotification")
    }
    private(set) var currencyList: [CartCurrency] = []
    var numberOfCurrencies: Int { currencyList.count }

    func getCurrencyList() {
        currencyList.removeAll()
        NotificationCenter.default.post(
            name: self.cartCurrencyListDidChangeNotification,
            object: nil
        )
        CurrencyListService.shared.get(onResponse: cartCurreencyDidReceive)
    }

    private func cartCurreencyDidReceive(_ result: Result<CartCurrencyList, Error>) {
        switch result {
        case .success(let currencies):
            currencyList.removeAll()
            currencyList = currencies.currencyList
            NotificationCenter.default.post(
                name: self.cartCurrencyListDidChangeNotification,
                object: nil
            )
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        }
    }
}
