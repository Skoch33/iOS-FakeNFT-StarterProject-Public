//
//  SelectCurrencyViewModel.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 19.10.2023.
//

import Foundation

protocol SelectCurrencyViewModelProtocol {
    func viewDidLoad()
    func backButtonDidTap()
    func userAgreementDidTap()
    func payButtonDidTap()
}

final class SelectCurrencyViewModel: SelectCurrencyViewModelProtocol {
    func backButtonDidTap() {
        // TODO: написать обработку нажатия кнопки "Назад"
    }

    func viewDidLoad() {
        // TODO: написать инициализацию viewModel'и
    }

    func userAgreementDidTap() {
        // TODO: реализовать переход на пользовательское соглашение
        print("пользовательское соглашение")
    }

    func payButtonDidTap() {
        // TODO: реализовать оплату
        print("оплата")
    }
}
