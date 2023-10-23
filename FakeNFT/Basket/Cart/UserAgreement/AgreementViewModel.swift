//
//  AgreementViewModel.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 23.10.2023.
//

protocol AgreementViewModelProtocol {
    func bind(_ bindings: AgreementViewModelBindings)
    func viewDidLoad()
    func backButtonDidTap()
}

final class AgreementViewModel: AgreementViewModelProtocol {

    @Observable private var isViewDismissing: Bool = false
    @Observable private var isWebViewLoading: Bool = false

    func bind(_ bindings: AgreementViewModelBindings) {
        self.$isViewDismissing.bind(action: bindings.isViewDismissing)
        self.$isWebViewLoading.bind(action: bindings.isWebViewLoading)
    }

    func viewDidLoad() {
        isWebViewLoading = true
    }

    func backButtonDidTap() {
        isViewDismissing = true
    }
}
