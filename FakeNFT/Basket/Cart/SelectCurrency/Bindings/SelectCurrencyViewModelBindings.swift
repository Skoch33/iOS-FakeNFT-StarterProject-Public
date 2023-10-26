//
//  SelectCurrencyViewModelBindings.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 22.10.2023.
//

import Foundation

struct SelectCurrencyViewModelBindings {
    let currencyList: ([CartCurrency]) -> Void
    let isViewDismissing: ClosureBool
    let isAgreementDisplaying: ClosureBool
    let isNetworkAlertDisplaying: ClosureBool
    let isPaymentResultDisplaying: (Bool?) -> Void
    let isCurrencyDidSelect: ClosureBool
}
