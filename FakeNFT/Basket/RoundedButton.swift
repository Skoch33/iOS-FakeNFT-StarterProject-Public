//
//  RoundedButton.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 09.10.2023.
//

import UIKit

final class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title: String) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
    }

    private func applyStyle() {
        backgroundColor = .nftBlack
        layer.cornerRadius = 16
        layer.masksToBounds = true
        titleLabel?.font = .NftBodyFonts.bold
        setTitleColor(.nftWhite, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
