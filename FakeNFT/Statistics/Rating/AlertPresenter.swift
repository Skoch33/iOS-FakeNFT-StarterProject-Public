//
//  AlertPresenter.swift
//  FakeNFT
//

import UIKit

struct AlertActionModel {
    var title: String
    var style: UIAlertAction.Style
    var handler: ((UIAlertAction) -> Void)?
}

protocol AlertPresenterProtocol {
    func showAlert(from view: UIViewController)
}

final class AlertPresenter: AlertPresenterProtocol {
    private var title: String?
    private var message: String?
    private var actions: [AlertActionModel]
    private var style: UIAlertController.Style

    init(
        title: String? = nil,
        message: String? = nil,
        actions: [AlertActionModel],
        style: UIAlertController.Style
    ) {
        self.title = title
        self.message = message
        self.actions = actions
        self.style = style
    }

    func showAlert(from view: UIViewController) {
        let alert = UIAlertController(
            title: title,
            message: message, preferredStyle: style
        )

        actions.forEach { actionModel in
            let action = UIAlertAction(
                title: actionModel.title,
                style: actionModel.style,
                handler: actionModel.handler
            )
            alert.addAction(action)
        }

        view.present(alert, animated: true)
    }
}
