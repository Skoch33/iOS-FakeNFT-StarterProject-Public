import UIKit
import Kingfisher

final class CollectionViewController: UIViewController {
    
    private enum Const {
        static let cellMargins: CGFloat = 9
        static let cellCols: CGFloat = 3
        static let sideMargins: CGFloat = 16
    }
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()
    
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .nftWhite
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .nftBlack
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        
        setupScrollView()
        setupCoverImage()
        setupNameLabel()
        setupAuthorTitleLabel()
        setupAuthorNameLabel()
        setupDescriptionLabel()
        setupCollectionView()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func setupCoverImage() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(coverImage)
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: 310),
            coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        guard
            let urlString = collection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString)
        else {
            return
        }
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: url, placeholder: nulPhotoImage)
    }
    
    private func setupNameLabel() {
        nameLabel.text = collection.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupAuthorTitleLabel() {
        authorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(authorTitleLabel)
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
        scrollView.addSubview(authorNameLabel)
        NSLayoutConstraint.activate([
            authorNameLabel.topAnchor.constraint(equalTo: authorTitleLabel.topAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorTitleLabel.trailingAnchor, constant: 4)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = collection.description
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(descriptionLabel)
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
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            collectionView.heightAnchor.constraint(equalToConstant: 800),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell",
                                                            for: indexPath) as? CollectionViewCell else {
            assertionFailure("Error get cell")
            return .init()
        }
        cell.configure()
        collectionViewCell = cell
        return collectionViewCell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.width - Const.cellMargins * (Const.cellCols - 1)) / Const.cellCols - 0.01
            return CGSize(width: width, height: 108)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 9
        }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
