//
//  AlertPresenter.swift
//  FakeNFT
//

import UIKit

struct AlertModel {
    let message: String
    let style: UIAlertController.Style
    let completion: ((UIAlertAction) -> Void)
}

protocol NetworkAlertProtocol {
    func showAlert(_ alert: AlertModel)
}

protocol NetworkAlertDelegate: AnyObject {
    func presentNetworkAlert(_ alert: UIAlertController)
}

final class NetworkAlert: NetworkAlertProtocol {
    weak var delegate: NetworkAlertDelegate?

    init(delegate: NetworkAlertDelegate) {
        self.delegate = delegate
    }

    func showAlert(_ alert: AlertModel) {
        let alertController = UIAlertController(
            title: nil,
            message: alert.message,
            preferredStyle: alert.style
        )

        let retryButton = UIAlertAction(title: "Повторить", style: .cancel, handler: alert.completion)
        let cancelButton = UIAlertAction(title: "Отмена", style: .default)

        alertController.addAction(cancelButton)
        alertController.addAction(retryButton)

        delegate?.presentNetworkAlert(alertController)
    }
}
