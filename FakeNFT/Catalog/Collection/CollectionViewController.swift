import UIKit
import Kingfisher

final class CollectionViewController: UIViewController {

    private var coverImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline2
        label.textColor = .nftBlack
        return label
    }()

    private var collection: CollectionModel

    init(collection: CollectionModel) {
        self.collection = collection
        super.init(nibName: nil, bundle: nil)
    }

    private let authorTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nftBlack
        label.text = NSLocalizedString("Collection.AuthorLabel", comment: "")
        return label
    }()

    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nftBlueUniversal
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nftBlack
        label.numberOfLines = 0
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .nftWhite
        self.tabBarController?.tabBar.isHidden = true
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .nftBlack
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem

        setupCoverImage()
        setupNameLabel()
        setupAuthorTitleLabel()
        setupAuthorNameLabel()
        setupDescriptionLabel()
    }

    private func setupCoverImage() {
        coverImage.kf.indicatorType = .activity
        guard let url = URL(string: collection.cover) else { return }
        coverImage.kf.setImage(with: url, placeholder: nulPhotoImage)
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coverImage)
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: view.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: 310),
            coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupNameLabel() {
        nameLabel.text = collection.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func setupAuthorTitleLabel() {
        authorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authorTitleLabel)
        NSLayoutConstraint.activate([
            authorTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            authorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func setupAuthorNameLabel() {
        authorNameLabel.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        authorNameLabel.addGestureRecognizer(guestureRecognizer)
        authorNameLabel.text = "Author Name"
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authorNameLabel)
        NSLayoutConstraint.activate([
            authorNameLabel.topAnchor.constraint(equalTo: authorTitleLabel.topAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorTitleLabel.trailingAnchor, constant: 4)
        ])
    }

    private func setupDescriptionLabel() {
        descriptionLabel.text = collection.description
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc
    func labelClicked(_ sender: Any) {
        let webViewController = WebViewController("https://practicum.yandex.ru/go-basics/")
        navigationController?.pushViewController(webViewController, animated: true)
    }

}
