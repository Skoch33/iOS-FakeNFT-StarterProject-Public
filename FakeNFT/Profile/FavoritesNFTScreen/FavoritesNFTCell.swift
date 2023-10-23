import UIKit

final class FavoritesNFTCell: UICollectionViewCell, ReuseIdentifying {
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        return label
    }()
    
    private var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "favouritesIcons")
        return imageView
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
        view.spacing = CGFloat(2)
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    private let nftDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private var name: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStarsState(_ state: Int) {
        starsImage.enumerated().forEach { position, star in
            let color = position < state ? UIColor.nftYellowUniversal : UIColor.nftLightgrey
            star.image = UIImage(named: "stars")?.withTintColor(color, renderingMode: .alwaysOriginal)
        }
    }
    
    private func setupViews() {
        nftImageView.addViewWithNoTAMIC(likeImageView)
        [name, starsView, currentPriceLabel].forEach { nftDetailsStackView.addArrangedSubview($0) }
        [nftImageView, nftDetailsStackView].forEach { contentView.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            
            nftDetailsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftDetailsStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12)
        ])
    }
    
    func configure() {
        self.nftImageView.image = UIImage(named: "NFT")
        setStarsState(3)
        self.name.text = "Archie"

        if let formattedPrice = NumberFormatter.defaultPriceFormatter.string(from: NSNumber(value: 1.98)) {
            self.currentPriceLabel.text = "\(formattedPrice) ETH"
        }
    }
    
}
