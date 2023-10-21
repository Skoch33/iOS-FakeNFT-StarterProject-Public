import UIKit

final class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionCell"
    
    private lazy var cardImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(likeButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var starsImage: [UIImageView] = {
        (1...5).map { _ in
            let view = UIImageView()
            view.image = UIImage()
            return view
        }
    }()
    
    private lazy var starsView: UIStackView = {
        let view = UIStackView(arrangedSubviews: starsImage)
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 0.75
        return view
    }()
    
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.nftBlack
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption3
        label.textColor = UIColor.nftBlack
        return label
    }()
    
    private lazy var cardButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(cardButtonTap), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.backgroundColor = .clear
        [cardImage, likeButton, starsView,
         nameLabel, priceLabel, cardButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        setupCardImage()
        setupLikeButton()
        setupStarsView()
        setupNameLabel()
        setupPriceLabel()
        setupCardButton()
    }
    
    private func setupCardImage() {
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImage.heightAnchor.constraint(equalTo: cardImage.widthAnchor)
        ])
    }
    
    private func setupLikeButton() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: cardImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cardImage.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setupStarsView() {
        NSLayoutConstraint.activate([
            starsView.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 8),
            starsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.75),
            starsView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func setupNameLabel() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    private func setupPriceLabel() {
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 51),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    private func setupCardButton() {
        NSLayoutConstraint.activate([
            cardButton.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 24),
            cardButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardButton.heightAnchor.constraint(equalToConstant: 40),
            cardButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    func configure(nft: NftModel, likes: [String], order: [String]) {
        let urlString = nft.images[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString ?? "")
        
        cardImage.kf.indicatorType = .activity
        cardImage.kf.setImage(with: url, placeholder: nulPhotoImage)
        
        let isLiked = likes.contains(where: { $0 == nft.id })
        setLikeButtonState(isLiked)
        
        setStarsState(nft.rating)
        
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        
        let isOrdered = order.contains(where: { $0 == nft.id})
        setCardButtonState(isOrdered)
    }
    
    func setLikeButtonState(_ state: Bool) {
        let color = state ? UIColor.nftRedUniversal : UIColor.nftWhiteUniversal
        likeButton.setImage(UIImage(named: "Catalog.likeButton")?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    func setStarsState(_ state: Int) {
        starsImage.enumerated().forEach { position, star in
            let color = position < state ? UIColor.nftYellowUniversal : UIColor.nftLightgrey
            star.image = UIImage(named: "Catalog.starImage")?.withTintColor(color, renderingMode: .alwaysOriginal)
        }
    }
    
    func setCardButtonState(_ state: Bool) {
        let name = state ? "Catalog.CardFull" : "Catalog.CardEmpty"
        cardButton.setImage(UIImage(named: name)?.withTintColor(.nftBlack, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    @objc
    func likeButtonTap() {
//        likeState = !likeState
//        setLikeButtonState(likeState)
//        setStarsState(likeState ? 4 : 3)
    }
    
    @objc
    func cardButtonTap() {
//        cardState = !cardState
//        setCardButtonState(cardState)
    }
}
