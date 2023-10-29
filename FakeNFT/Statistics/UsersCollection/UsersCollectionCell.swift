//
//  UsersCollectionCell.swift
//  FakeNFT
//

import UIKit
import Kingfisher

final class UsersCollectionCell: UICollectionViewCell {
    static let identifier = "UsersCollectionCell"
    var likeButtonTappedHandler: (() -> Void)?
    var basketButtonTappedHandler: (() -> Void)?
    // MARK: - Private Properties
    private var isLiked: Bool = false
    private var isOrder: Bool = false
    private let placeholder = UIImage(systemName: "xmark.circle")
    // MARK: - SubViews
    private lazy var imageNFT: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.tintColor = .nftBlack
        return image
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(.noActiveLike, for: .normal)
        button.addTarget(self, action: #selector(isLikeTapped), for: .touchUpInside)
        return button
    }()

    private lazy var ratingImages: [UIImageView] = {
        var images = [UIImageView]()
        for _ in 0..<5 {
            let image = UIImageView(image: .defaultStarIcon)
            images.append(image)
        }
        return images
    }()

    private lazy var nameNFT: UILabel = {
        let label = UILabel()
        label.font = .NftBodyFonts.bold
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .NftCaptionFonts.small
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
        setIsLiked(isLiked: isLiked)
        likeButtonTappedHandler?()
    }

    @objc
    private func isOrderTapped() {
        isOrder.toggle()
        setIsOrder(isOrder: isOrder)
        basketButtonTappedHandler?()
        let lightOrder: UIImage? = isOrder ? .basketLightIsOrder : .basketDark
        let darkOrder: UIImage? = isOrder ? .basketDarkIsOrder : .basketLight
        if traitCollection.userInterfaceStyle == .light {
            basketButton.setImage(lightOrder, for: .normal)
        } else {
            basketButton.setImage(darkOrder, for: .normal)
        }
    }
    // MARK: - AutoLayouts
    private func setupUI() {
        [imageNFT, favoriteButton, nameNFT, priceLabel, basketButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        for idx in 0..<ratingImages.count {
            ratingImages[idx].translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(ratingImages[idx])
            NSLayoutConstraint.activate([
                ratingImages[idx].topAnchor.constraint(equalTo: imageNFT.bottomAnchor, constant: 8)
            ])
        }

        for idx in 1..<ratingImages.count {
            NSLayoutConstraint.activate([
                ratingImages[idx].leadingAnchor.constraint(equalTo: ratingImages[idx-1].trailingAnchor, constant: 2)
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
    // MARK: - Setup
    func configure(nft: NFTModel, rating: Int, isLiked: Bool, isOrder: Bool) {
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
        setIsLiked(isLiked: isLiked)
        setIsOrder(isOrder: isOrder)
        setupStarRating(with: rating)
    }

    private func setIsLiked(isLiked: Bool) {
        let like: UIImage? = isLiked ? .activeLike : .noActiveLike
        favoriteButton.setImage(like, for: .normal)
    }

    private func setIsOrder(isOrder: Bool) {
        let lightOrder: UIImage? = isOrder ? .basketLightIsOrder : .basketDark
        let darkOrder: UIImage? = isOrder ? .basketDarkIsOrder : .basketLight
        if traitCollection.userInterfaceStyle == .light {
            basketButton.setImage(lightOrder, for: .normal)
        } else {
            basketButton.setImage(darkOrder, for: .normal)
        }
    }

    private func setupStarRating(with rating: Int) {
        for index in 0..<ratingImages.count {
            let star: UIImage? = index < rating ? .starDoneIcon : .defaultStarIcon
            ratingImages[index].image = star
        }
    }

    private func updateBasketColor() {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                basketButton.setImage(.basketDark, for: .normal)
            } else {
                basketButton.setImage(.basketLight, for: .normal)
            }
        } else {
            basketButton.setImage(.basketDark, for: .normal)
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageNFT.kf.cancelDownloadTask()
    }
}
