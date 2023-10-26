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
    func didUpdateProgressValue(_ newValue: Double)
}

final class AgreementViewModel: AgreementViewModelProtocol {

    @Observable private var isViewDismissing: Bool = false
    @Observable private var isContentLoading: Bool = false
    @Observable private var isContentProgressHidden: Bool = true
    @Observable private var contentLoadingProgress: Float = 0.0

    func bind(_ bindings: AgreementViewModelBindings) {
        self.$isViewDismissing.bind(action: bindings.isViewDismissing)
        self.$isContentLoading.bind(action: bindings.isContentLoading)
        self.$isContentProgressHidden.bind(action: bindings.isContentProgressHidden)
        self.$contentLoadingProgress.bind(action: bindings.contentLoadingProgress)
    }

    func viewDidLoad() {
        isContentLoading = true
    }

    func backButtonDidTap() {
        isViewDismissing = true
    }

    func didUpdateProgressValue(_ newValue: Double) {
        contentLoadingProgress = Float(newValue)
        isContentProgressHidden = shouldHideProgress(for: contentLoadingProgress)
    }

    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
