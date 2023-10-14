import UIKit

final class CollectionViewCell: UICollectionViewCell {

    private var label: UILabel = {
        let lLabel = UILabel()
        lLabel.font = UIFont.boldSystemFont(ofSize: 32)
        lLabel.textAlignment = .center
        return lLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        layer.cornerRadius = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure() {
        label.text = "1"
        self.backgroundColor = .nftBlueUniversal
    }
}
