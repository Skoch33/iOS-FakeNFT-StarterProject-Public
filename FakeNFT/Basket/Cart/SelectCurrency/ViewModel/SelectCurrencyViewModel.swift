//
//  SelectCurrencyViewModel.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 19.10.2023.
//

import Foundation

protocol SelectCurrencyViewModelProtocol: AlertServiceDelegate {
    func viewDidLoad()
    func bind(_ bindings: SelectCurrencyViewModelBindings)
    func backButtonDidTap()
    func userAgreementDidTap()
    func payButtonDidTap()
    func pullToRefreshDidTrigger()
    func didSelectCurrency(_ currency: String)
}

final class SelectCurrencyViewModel: SelectCurrencyViewModelProtocol {
    private var dataProvider: CartCurrencyDataProviderProtocol

    @Observable private var currencyList: [CartCurrency]
    @Observable private var isViewDismissing: Bool
    @Observable private var isAgreementDisplaying: Bool
    @Observable private var isNetworkAlertDisplaying: Bool
    @Observable private var isPaymentResultDisplaying: Bool?
    @Observable private var isCurrencyDidSelect: Bool

    private var selectedCurrency: String?

    init(dataProvider: CartCurrencyDataProviderProtocol) {
        self.currencyList = []
        self.dataProvider = dataProvider
        self.isViewDismissing = false
        self.isAgreementDisplaying = false
        self.isNetworkAlertDisplaying = false
        self.isCurrencyDidSelect = false
    }

    func backButtonDidTap() {
        isViewDismissing = true
    }

    func viewDidLoad() {
        subscribeDataProviderNotifications()
        dataProvider.reloadData()
    }

    func bind(_ bindings: SelectCurrencyViewModelBindings) {
        self.$currencyList.bind(action: bindings.currencyList)
        self.$isViewDismissing.bind(action: bindings.isViewDismissing)
        self.$isAgreementDisplaying.bind(action: bindings.isAgreementDisplaying)
        self.$isNetworkAlertDisplaying.bind(action: bindings.isNetworkAlertDisplaying)
        self.$isPaymentResultDisplaying.bind(action: bindings.isPaymentResultDisplaying)
        self.$isCurrencyDidSelect.bind(action: bindings.isCurrencyDidSelect)
    }

    func userAgreementDidTap() {
        isAgreementDisplaying = true
    }

    func payButtonDidTap() {
        guard let selectedCurrency else { return }
        CartPaymentService.shared.pay(withCurrency: selectedCurrency, onResponse: paymentResultDidReceive)
    }

    func pullToRefreshDidTrigger() {
        dataProvider.reloadData()
    }

    func didSelectCurrency(_ currency: String) {
        selectedCurrency = currency
        isCurrencyDidSelect = true
    }

    private func paymentResultDidReceive(_ result: Result<Bool, Error>) {
        switch result {
        case .success(let isPaymentSuccessful):
            self.isPaymentResultDisplaying = isPaymentSuccessful
        case .failure:
            isNetworkAlertDisplaying = true
        }
    }

    private func dataProviderDidUpdateCurrencyList() {
        currencyList = dataProvider.getCurrencyList()
    }

    private func networkFailureDidGet() {
        isNetworkAlertDisplaying = true
    }

    private func subscribeDataProviderNotifications() {
        NotificationCenter.default.addObserver(
            forName: dataProvider.cartCurrencyListDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.dataProviderDidUpdateCurrencyList()
        }

        NotificationCenter.default.addObserver(
            forName: dataProvider.cartCurrencyListChangeNotificationFailed,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.networkFailureDidGet()
        }
    }
}

extension SelectCurrencyViewModel: AlertServiceDelegate {
    func networkAlertDidCancel() {
        isNetworkAlertDisplaying = false
    }

    func networkAlertRepeatDidTap() {
        isNetworkAlertDisplaying = false
        dataProvider.reloadData()
    }
}
