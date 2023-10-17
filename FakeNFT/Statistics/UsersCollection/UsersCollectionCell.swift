//
//  UsersCollectionCell.swift
//  FakeNFT
//

import UIKit
import Kingfisher

final class UsersCollectionCell: UICollectionViewCell {
    static let identifier = "UsersCollectionCell"
    // MARK: - Private Properties
    private var isLiked: Bool = false
    private var isOrder: Bool = false
    private let placeholder = UIImage(named: "person.crop.circle.fill")
    // MARK: - SubViews
    private lazy var imageNFT: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()

    private lazy var favoriteButton: UIButton = {
        let favorite = UIImage(named: "noActiveLike")
        let button = UIButton()
        button.setImage(favorite, for: .normal)
        button.addTarget(self, action: #selector(isLikeTapped), for: .touchUpInside)
        return button
    }()

    private lazy var ratingImages: [UIImageView] = {
        var images = [UIImageView]()
        for _ in 0..<5 {
            let star = UIImage(named: "starDefault")
            let image = UIImageView(image: star)
            images.append(image)
        }
        return images
    }()

    private lazy var nameNFT: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        return label
    }()

    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(isOrderTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .nftWhite
        setupUI()
        updateBasketColor()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(
                comparedTo: previousTraitCollection
            ) {
                updateBasketColor()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions
    @objc
    private func isLikeTapped() {
        isLiked.toggle()
        let like = isLiked ? "activeLike" : "noActiveLike"
        favoriteButton.setImage(UIImage(named: like), for: .normal)
    }

    @objc
    private func isOrderTapped() {
        isOrder.toggle()
        let lightOrder = isOrder ? "basketLightOrder" : "basketDark"
        let darkOrder = isOrder ? "basketDarkOrder" : "basketLight"
        if traitCollection.userInterfaceStyle == .light {
            basketButton.setImage(UIImage(named: lightOrder), for: .normal)
        } else {
            basketButton.setImage(UIImage(named: darkOrder), for: .normal)
        }
    }
    // MARK: - AutoLayouts
    private func setupUI() {
        [imageNFT, favoriteButton, nameNFT, priceLabel, basketButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        for i in 0..<ratingImages.count {
            ratingImages[i].translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(ratingImages[i])
            NSLayoutConstraint.activate([
                ratingImages[i].topAnchor.constraint(equalTo: imageNFT.bottomAnchor, constant: 8),
            ])
        }

        for i in 1..<ratingImages.count {
            NSLayoutConstraint.activate([
                ratingImages[i].leadingAnchor.constraint(equalTo: ratingImages[i-1].trailingAnchor, constant: 2),
            ])
        }

        NSLayoutConstraint.activate([
            imageNFT.heightAnchor.constraint(equalToConstant: 108),
            imageNFT.widthAnchor.constraint(equalToConstant: 108),
            imageNFT.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageNFT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageNFT.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            favoriteButton.topAnchor.constraint(equalTo: imageNFT.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: imageNFT.trailingAnchor),

            ratingImages[0].leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            nameNFT.topAnchor.constraint(equalTo: ratingImages[0].bottomAnchor, constant: 5),
            nameNFT.leadingAnchor.constraint(equalTo: leadingAnchor),

            priceLabel.topAnchor.constraint(equalTo: nameNFT.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            basketButton.heightAnchor.constraint(equalToConstant: 40),
            basketButton.widthAnchor.constraint(equalToConstant: 40),
            basketButton.topAnchor.constraint(equalTo: imageNFT.bottomAnchor, constant: 24),
            basketButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    //MARK: - Setup
    func configure(nft: NFT, rating: Int) {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()

        imageNFT.kf.indicatorType = .activity
        if let url = URL(string: nft.images.first ?? "") {
            imageNFT.kf.setImage(
                with: url,
                placeholder: placeholder
            )
        }
        nameNFT.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        setupStarRating(with: rating)
    }

    private func setupStarRating(with rating: Int) {
        for index in 0..<ratingImages.count {
            let star = index < rating ? "starDone" : "starDefault"
            ratingImages[index].image = UIImage(named: star)
        }
    }

    private func updateBasketColor() {
        let darkBasket = UIImage(named: "basketDark")
        let lightBasket = UIImage(named: "basketLight")
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                basketButton.setImage(darkBasket, for: .normal)
            } else {
                basketButton.setImage(lightBasket, for: .normal)
            }
        } else {
            basketButton.setImage(darkBasket, for: .normal)
        }
    }
}
