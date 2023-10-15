import UIKit
import Kingfisher

final class CatalogCell: UITableViewCell {
    static let identifier = "CatalogCell"

    private var collectionImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .nftBlack
        label.font = .bodyBold
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
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
            collectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionImage.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: collectionImage.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }

    func config(_ collection: CollectionModel) {
        self.selectionStyle = .none

        nameLabel.text = "\(collection.name) (\(collection.nfts.count))"

        guard
            let urlString = collection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString)
        else {
            return
        }
        collectionImage.kf.indicatorType = .activity
        collectionImage.kf.setImage(with: url, placeholder: nulPhotoImage)
    }

}
