//
//  OnboardingView.swift
//  FakeNFT
//

import UIKit

final class OnboardingView: UIView {
    // MARK: - Private Subviews
    private lazy var onboardingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    // MARK: - Init
    init(frame: CGRect, image: UIImage, headerText: String, descriptionText: String) {
        super.init(frame: frame)
        onboardingImage.image = image
        headerLabel.text = headerText
        descriptionLabel.text = descriptionText
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup Subviews
    private func setupSubviews() {
        [headerLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
            $0.textColor = .white
        }

        NSLayoutConstraint.activate([
            onboardingImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            onboardingImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            onboardingImage.topAnchor.constraint(equalTo: topAnchor),
            onboardingImage.bottomAnchor.constraint(equalTo: bottomAnchor),

            headerLabel.topAnchor.constraint(equalTo: onboardingImage.safeAreaLayoutGuide.topAnchor, constant: 230),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor)
        ])
        layoutIfNeeded()
    }
    // MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientFrame = onboardingImage.bounds
        let colorTop = UIColor.nftBlackUniversal
        let colorBottom = UIColor.lightGradient
        onboardingImage.addGradient([colorTop, colorBottom], locations: [0.0, 1.0], frame: gradientFrame)
    }
}
// MARK: - UIView + Extentions
extension UIView {
    func addGradient(_ colors: [UIColor], locations: [NSNumber], frame: CGRect = .zero) {
        if let oldGradientLayer = layer.sublayers?.filter({ $0 is CAGradientLayer }).first {
            oldGradientLayer.removeFromSuperlayer()
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
