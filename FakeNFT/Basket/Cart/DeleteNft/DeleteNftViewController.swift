//
//  DeleteNftViewController.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 13.10.2023.
//

import UIKit
import Kingfisher

class DeleteNftViewController: UIViewController {

    var nftImage: UIImage?
    var nftImageURL: URL?
    var nftId: String?

    private lazy var nftImageView = createNFTImageView()

    override var prefersStatusBarHidden: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @objc private func deleteButtonDidTap() {
        print("delete nft \(nftId!)")
    }

    @objc private func backButtonDidTap() {
        dismiss(animated: true)
    }
}

// MARK: Setup & Layout UI
private extension DeleteNftViewController {
    func setupUI() {
        blurBackground()

        let label = UILabel()
        label.text = NSLocalizedString("Cart.DeleteNftViewController.deleteMessage", comment: "")
        label.font = .caption2
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .nftBlack

        let messageStack = UIStackView(arrangedSubviews: [nftImageView, label])
        messageStack.axis = .vertical
        messageStack.spacing = 12
        messageStack.distribution = .fill
        messageStack.alignment = .center

        let deleteButtonTitle = NSLocalizedString("Cart.DeleteNftViewController.deleteButton", comment: "")
        let deleteButton = RoundedButton(title: deleteButtonTitle)
        deleteButton.setTitleColor(.nftRedUniversal, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)

        let backButtonTitle = NSLocalizedString("Cart.DeleteNftViewController.backButton", comment: "")
        let backButton = RoundedButton(title: backButtonTitle)
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)

        [deleteButton, backButton].forEach {
            $0.layer.cornerRadius = 12
            $0.contentEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
            $0.titleLabel?.font = .bodyRegular
        }

        let buttonsStack = UIStackView(arrangedSubviews: [deleteButton, backButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8
        buttonsStack.distribution = .fillEqually
        buttonsStack.alignment = .center

        let mainStack = UIStackView(arrangedSubviews: [messageStack, buttonsStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.distribution = .fill
        mainStack.alignment = .center

        [label, messageStack, buttonsStack, mainStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            label.widthAnchor.constraint(equalToConstant: 180),

            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func blurBackground() {
        self.modalPresentationCapturesStatusBarAppearance = true
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurredView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurredView)

        NSLayoutConstraint.activate([
            blurredView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurredView.topAnchor.constraint(equalTo: view.topAnchor),
            blurredView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurredView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func createNFTImageView() -> UIImageView {
        let imageView = UIImageView()
        if let nftImage {
            imageView.image = nftImage
        } else {
            imageView.kf.setImage(with: nftImageURL)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
