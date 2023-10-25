//
//  CartAlertController.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 18.10.2023.
//

import UIKit

struct CartAlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: AlertActionClosure

    init(title: String, style: UIAlertAction.Style = .default, handler: AlertActionClosure = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    typealias AlertActionClosure = ((UIAlertAction) -> Void)?
}

final class CartAlertController {

    private weak var delegate: UIViewController?
    private let alertStyle: UIAlertController.Style
    private let title: String?
    private let message: String?
    private let actions: [CartAlertAction]

    init(
        delegate: UIViewController,
        title: String? = nil,
        message: String? = nil,
        actions: [CartAlertAction],
        style: UIAlertController.Style = .alert
    ) {
        self.delegate = delegate
        self.title = title
        self.message = message
        self.actions = actions
        self.alertStyle = style
    }

    func show() {
        let controller = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        actions.forEach {
            let action = UIAlertAction(title: $0.title, style: $0.style, handler: $0.handler)
            controller.addAction(action)
        }
        delegate?.present(controller, animated: true)
    }
}
