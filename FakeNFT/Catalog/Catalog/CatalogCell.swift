import UIKit
import Kingfisher

final class CatalogCell: UITableViewCell {
    static let identifier = "CatalogCell"

    private var collectionImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .nftBlack
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionImage()
        setupNameLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionImage() {
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionImage)
        NSLayoutConstraint.activate([
            collectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImage.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: collectionImage.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }

    func config(_ collection: CollectionModel) {
        self.selectionStyle = .none

        nameLabel.text = "\(collection.name) (\(collection.nfts.count))"

        guard let url = URL(string: collection.cover) else { return }
        collectionImage.kf.indicatorType = .activity
        collectionImage.kf.setImage(with: url, placeholder: nulPhotoImage)
    }

}
