//
//  CurrencyViewCell.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 19.10.2023.
//

import UIKit

final class CurrencyViewCell: UICollectionViewCell, ReuseIdentifying {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .nftLightgrey
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
