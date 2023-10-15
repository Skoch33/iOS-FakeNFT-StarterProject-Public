import UIKit

final class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionCell"
    var likeState = false
    var cardState = false
    
    private var cardImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(likeButtonTap), for: .touchUpInside)
        return button
    }()
    
    private var starsImage: [UIImageView] = {
        (1...5).map { _ in
            let view = UIImageView()
            view.image = UIImage()
            return view
        }
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor.nftBlack
        return label
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption3
        label.textColor = UIColor.nftBlack
        return label
    }()
    
    private var cardButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(cardButtonTap), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        setupCardImage()
        setupLikeButton()
        setupStartsView()
        setupNameLabel()
        setupPriceLabel()
        setupCardButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCardImage() {
        cardImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardImage)
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImage.heightAnchor.constraint(equalTo: cardImage.widthAnchor)
        ])
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: cardImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cardImage.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setupStartsView() {
        let starsView = UIStackView(arrangedSubviews: starsImage)
        starsView.axis = .horizontal
        starsView.alignment = .center
        starsView.spacing = 0.75
        
        starsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(starsView)
        NSLayoutConstraint.activate([
            starsView.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 8),
            starsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.75),
            starsView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    private func setupPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 51),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    private func setupCardButton() {
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardButton)
        NSLayoutConstraint.activate([
            cardButton.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 24),
            cardButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardButton.heightAnchor.constraint(equalToConstant: 40),
            cardButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }


    func configure() {
        
        let urlString = "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Aurora/1.png"
        guard
            let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString)
        else {
            return
        }
        cardImage.kf.indicatorType = .activity
        cardImage.kf.setImage(with: url, placeholder: nulPhotoImage)
        
        setLikeButtonState(false)
        setStarsState(3)
        
        nameLabel.text = "Aurora"
        priceLabel.text = "1 ETH"
        
        setCardButtonState(false)
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
        likeState = !likeState
        setLikeButtonState(likeState)
        setStarsState(likeState ? 4 : 3)
    }
    
    @objc
    func cardButtonTap() {
        cardState = !cardState
        setCardButtonState(cardState)
    }
}
