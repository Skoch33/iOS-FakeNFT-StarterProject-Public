//
//  RatingView.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 10.10.2023.
//

import UIKit

final class RatingView: UIView {

    static let star = UIImage(systemName: "star.fill") ?? UIImage()

    var rating: Int = 0 {
        didSet {
            starsStackView = createStarsStackView()
            layoutStarsStackView()
        }
    }

    private let maxRating = 5
    private let interimSpacing = CGFloat(2)
    private lazy var starsStackView = createStarsStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(rating: Int) {
        self.init(frame: .zero)
        self.rating = rating
        setupUI()
    }
}

// MARK: SetupUI & Layout
private extension RatingView {
    func setupUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layoutStarsStackView()
    }

    func createStarsStackView() -> UIStackView {
        let stars: [UIImageView] = (1...maxRating).reduce([], {
            let view = UIImageView(image: RatingView.star)
            view.tintColor = $1 <= self.rating ? .nftYellowUniversal : .nftLightgrey
            return $0 + [view]
        })

        let stack = UIStackView(arrangedSubviews: stars)
        stack.axis = .horizontal
        stack.spacing = interimSpacing
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    func layoutStarsStackView() {
        starsStackView.removeFromSuperview()
        addSubview(starsStackView)
        NSLayoutConstraint.activate([
            starsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starsStackView.topAnchor.constraint(equalTo: topAnchor),
            starsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            starsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            starsStackView.widthAnchor.constraint(
                equalTo: starsStackView.heightAnchor,
                multiplier: CGFloat(maxRating),
                constant: interimSpacing * CGFloat(maxRating - 1)
            )
        ])
    }
}
