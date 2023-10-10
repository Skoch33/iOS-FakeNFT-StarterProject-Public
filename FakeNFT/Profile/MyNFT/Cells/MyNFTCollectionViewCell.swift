//
//  MyNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Semen Kocherga on 10.10.2023.
//

import UIKit

class MyNFTCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .bodyBold
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var rateImage: UIImageView = {
        let rateImage = UIImageView()
        rateImage.translatesAutoresizingMaskIntoConstraints = false
        return rateImage
    }()
    
    private lazy var fromLabel: UILabel = {
        let fromLabel = UILabel()
        fromLabel.font = .caption2
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        return fromLabel
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let priceTitleLabel = UILabel()
        priceTitleLabel.font = .caption2
        priceTitleLabel.text = "Цена"
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceTitleLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .bodyBold
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
    }()
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rateImage)
        contentView.addSubview(fromLabel)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image View
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 108),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 78),
            
            rateImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            rateImage.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            rateImage.widthAnchor.constraint(equalToConstant: 78),
            
            fromLabel.topAnchor.constraint(equalTo: rateImage.bottomAnchor, constant: 4),
            fromLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            fromLabel.widthAnchor.constraint(equalToConstant: 78),
            
            priceTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33),
            priceTitleLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 70),
            priceTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 70),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellData(_ model: MyNFTCellViewModel) {
        imageView.image = model.nftImage
        nameLabel.text = model.nftName
        rateImage.image = model.nftRateImage
        fromLabel.text = model.nftFromName
        priceLabel.text = model.nftPrice + " ETH"
    }
}

extension MyNFTCollectionViewCell: ReuseIdentifying {
    static let defaultReuseIdentifier = "MyNFTCell"
}
