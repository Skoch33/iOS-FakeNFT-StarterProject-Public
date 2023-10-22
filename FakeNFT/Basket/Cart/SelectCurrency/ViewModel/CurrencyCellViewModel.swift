//
//  CurrencyCellViewModel.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 19.10.2023.
//

import Foundation

protocol CurrencyCellViewModelProtocol {
    func bind(_ bindings: CurrencyCellViewModelBindings)
    func cellReused(for currency: CartCurrency)
}

final class CurrencyCellViewModel: CurrencyCellViewModelProtocol {

    @Observable private var imageURL: URL?
    @Observable private var currencyName: String = ""
    @Observable private var currencyCode: String = ""

    private var currencyId: String = ""

    func bind(_ bindings: CurrencyCellViewModelBindings) {
        self.$imageURL.bind(action: bindings.imageURL)
        self.$currencyName.bind(action: bindings.currencyName)
        self.$currencyCode.bind(action: bindings.currencyCode)
    }

    func cellReused(for currency: CartCurrency) {
        imageURL = currency.imageURL
        currencyName = currency.name
        currencyCode = currency.title
        currencyId = currency.id
    }
}
