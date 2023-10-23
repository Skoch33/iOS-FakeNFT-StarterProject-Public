//
//  SuccessfulPaymentViewController.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 22.10.2023.
//

import UIKit

final class SuccessfulPaymentViewController: UIViewController {

    var onBackToCartViewController: (() -> Void)?
    private var viewModel: SuccessfulPaymentViewModelProtocol

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    init(viewModel: SuccessfulPaymentViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func backToCatalogDidTap() {
        viewModel.backToCatalogDidTap()
    }

    private func bindViewModel() {
        viewModel.bind(SuccessfulPaymentViewModelBindings(
            isViewDismissing: { [ weak self ] in
                if $0 {
                    self?.onBackToCartViewController?()
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        ))
    }
}

private extension SuccessfulPaymentViewController {
    func setupUI() {

        view.backgroundColor = .nftWhite
        navigationController?.isNavigationBarHidden = true

        let imageView = UIImageView(image: UIImage(named: "payment_success"))
        imageView.contentMode = .scaleAspectFill

        let label = UILabel()
        label.font = .NftHeadlineFonts.medium
        label.textColor = .nftBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "SuccessfulPaymentViewController.message".localized()

        let button = RoundedButton(title: "SuccessfulPaymentViewController.buttonTitle".localized())
        button.addTarget(self, action: #selector(backToCatalogDidTap), for: .touchUpInside)

        [imageView, label, button].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),

            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -152),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),

            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 49),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -20)
        ])
    }
}
