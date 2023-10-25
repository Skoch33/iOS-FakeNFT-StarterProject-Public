//
//  CartCurrencyDataProvider.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

protocol CartCurrencyDataProviderProtocol {
    func getNumberOfCurrencies() -> Int
    func getCurrencyList() -> [CartCurrency]
    func reloadData()
    func getCurrencyInfo(for id: String)
}

extension CartCurrencyDataProviderProtocol {
    var cartCurrencyListDidChangeNotification: Notification.Name {
        Notification.Name(rawValue: "cartCurrencyListDidChangeNotification")
    }
    var cartCurrencyListChangeNotificationFailed: Notification.Name {
        Notification.Name(rawValue: "cartCurrencyListDidChangeNotificationFailed")
    }
    var cartCurrencyGetInfoNotificationFailed: Notification.Name {
        Notification.Name(rawValue: "cartCurrencyGetInfoNotificationFailed")
    }
}

final class CartCurrencyDataProvider: CartCurrencyDataProviderProtocol {
    static let cartCurrencyNotificationUserInfo = "currencyInfo"
    private var currencyList: [CartCurrency] = []

    func getNumberOfCurrencies() -> Int {
        currencyList.count
    }

    func getCurrencyList() -> [CartCurrency] {
        currencyList
    }

    func reloadData() {
        currencyList.removeAll()
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
                name: cartCurrencyListDidChangeNotification,
                object: nil
            )
        case .failure:
            NotificationCenter.default.post(
                name: cartCurrencyListChangeNotificationFailed,
                object: nil
            )
        }
    }

    private func currencyInfoDidReceive(_ result: Result<CartCurrency, Error>) {
        switch result {
        case .success(let currency):
            NotificationCenter.default.post(
                name: cartCurrencyListDidChangeNotification,
                object: nil,
                userInfo: [Self.cartCurrencyNotificationUserInfo: currency]
            )
        case .failure:
            NotificationCenter.default.post(
                name: cartCurrencyListChangeNotificationFailed,
                object: nil
            )
        }
    }
}
