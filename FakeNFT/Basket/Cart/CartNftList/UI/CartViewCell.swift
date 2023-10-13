//
//  CartViewCell.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 09.10.2023.
//

import UIKit
import Kingfisher

final class CartViewCell: UITableViewCell, ReuseIdentifying {

    var viewModel: CartCellViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }

    private let layoutMargin: CGFloat = 16
    private lazy var nftImageView: UIImageView = createNFTImageView()
    private lazy var nftNameLabel: UILabel = createNFTNameLabel()
    private lazy var nftRatingView = RatingView(rating: .zero)
    private lazy var nftPriceLabel: UILabel = createNFTPriceLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func deleteButtonDidTap() {
        viewModel?.deleteButtonDidTap()
    }

    private func bindViewModel() {
        let bindings = CartCellViewModelBindings(
            rating: { [weak self] in
                self?.nftRatingView.rating = $0
            },
            price: { [weak self] in
                self?.nftPriceLabel.text = PriceFormatter.formattedPrice($0)
            },
            name: { [weak self] in
                self?.nftNameLabel.text = $0
            },
            imageURL: { [weak self] in
                self?.nftImageView.kf.setImage(with: $0)
            }
        )
        viewModel?.bind(bindings)
    }
}

// MARK: Setup UI & Layout
private extension CartViewCell {
    func setupUI() {

        backgroundColor = .nftWhite
        contentView.addSubview(nftImageView)
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layoutMargin),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layoutMargin),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -layoutMargin),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor)
        ])

        let infoView = createNFTInfoView()
        contentView.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            infoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 92)
        ])
        let deleteButton = createDeleteNFTButton()
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layoutMargin)
        ])
    }

    func createNFTImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func createNFTInfoView() -> UIView {
        let nameStackView = UIStackView(arrangedSubviews: [nftNameLabel, nftRatingView])
        nameStackView.axis = .vertical
        nameStackView.alignment = .leading
        nameStackView.spacing = 4
        nameStackView.distribution = .fill

        let priceView = UILabel()
        priceView.text = NSLocalizedString("CartViewCell.Price", comment: "")
        priceView.font = .caption2
        priceView.textColor = .nftBlack
        priceView.textAlignment = .left

        let priceStackView = UIStackView(arrangedSubviews: [priceView, nftPriceLabel])
        priceStackView.axis = .vertical
        priceStackView.alignment = .leading
        priceStackView.spacing = 2
        priceStackView.distribution = .fill

        let infoStackView = UIStackView(arrangedSubviews: [nameStackView, priceStackView])
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.spacing = 12
        infoStackView.distribution = .fill

        let view = UIView()
        view.addSubview(infoStackView)

        [nameStackView, priceView, priceStackView, infoStackView, view].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            nftRatingView.heightAnchor.constraint(equalToConstant: 12),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoStackView.topAnchor.constraint(equalTo: view.topAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return view
    }

    func createNFTNameLabel() -> UILabel {
        let label = UILabel()
        label.text = " "
        label.font = .bodyBold
        label.textColor = .nftBlack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createNFTPriceLabel() -> UILabel {
        let label = UILabel()
        label.text = PriceFormatter.formattedPrice(Decimal(0))
        label.font = .bodyBold
        label.textColor = .nftBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createDeleteNFTButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "action_delete"), for: .normal)
        button.tintColor = .nftBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        return button
    }
}
