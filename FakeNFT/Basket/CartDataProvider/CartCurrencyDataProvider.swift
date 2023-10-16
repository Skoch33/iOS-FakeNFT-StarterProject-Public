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
    func getCurrencyInfo(for id: String)
}

final class CartCurrencyDataProvider: CartCurrencyDataProviderProtocol {
    static let cartCurrencyNotificationUserInfo = "currencyInfo"
    static var cartCurrencyListDidChangeNotification: Notification.Name {
        Notification.Name(rawValue: "cartCurrencyListDidChangeNotification")
    }
    static var cartCurrencyGetInfoNotification: Notification.Name {
        Notification.Name(rawValue: "cartCurrencyGetInfoNotification")
    }

    private(set) var currencyList: [CartCurrency] = []
    var numberOfCurrencies: Int { currencyList.count }

    func getCurrencyList() {
        currencyList.removeAll()
        NotificationCenter.default.post(
            name: Self.cartCurrencyListDidChangeNotification,
            object: nil
        )
        CurrencyListService.shared.get(onResponse: cartCurrencyDidReceive)
    }

    func getCurrencyInfo(for id: String) {
        let infoService = CurrencyInfoService()
        infoService.get(for: id, onResponse: currencyInfoDidReceive)
    }

    private func cartCurrencyDidReceive(_ result: Result<CartCurrencyList, Error>) {
        switch result {
        case .success(let currencies):
            currencyList.removeAll()
            currencyList = currencies.currencyList
            NotificationCenter.default.post(
                name: Self.cartCurrencyListDidChangeNotification,
                object: nil
            )
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        }
    }

    private func currencyInfoDidReceive(_ result: Result<CartCurrency, Error>) {
        switch result {
        case .success(let currency):
            NotificationCenter.default.post(
                name: Self.cartCurrencyListDidChangeNotification,
                object: nil,
                userInfo: [Self.cartCurrencyNotificationUserInfo: currency]
            )
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        }
    }
}
