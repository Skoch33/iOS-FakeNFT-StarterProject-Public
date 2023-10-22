//
//  DefaultAlertService.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 22.10.2023.
//

import UIKit

@objc protocol AlertServiceDelegate {
    @objc optional func networkAlertDidCancel()
    @objc optional func networkAlertRepeatDidTap()
}

final class DefaultAlertService {
    private var delegate: AlertServiceDelegate
    private var presentingViewController: UIViewController

    init(delegate: AlertServiceDelegate, controller: UIViewController) {
        self.delegate = delegate
        self.presentingViewController = controller
    }

    func presentNetworkErrorAlert() {
        let title = "DefaultNetworkAlert.title".localized()
        let message = "DefaultNetworkAlert.message".localized()
        let okActionTitle = "DefaultNetworkAlert.OkAction.title".localized()
        let repeatActionTitle = "DefaultNetworkAlert.RepeatAction.title".localized()

        let controller = CartAlertController(
            delegate: presentingViewController,
            title: title,
            message: message,
            actions: [
                CartAlertAction(title: okActionTitle, style: .cancel) { [weak self] _ in
                    self?.delegate.networkAlertDidCancel?()
                },
                CartAlertAction(title: repeatActionTitle) { [weak self] _ in
                    self?.delegate.networkAlertRepeatDidTap?()
                }
            ]
        )
        controller.show()
    }
}
