import UIKit
import Kingfisher
import ProgressHUD

final class CollectionViewController: UIViewController {
    
    private var collectionViewModel: CollectionViewModelProtocol
    private var collection: CollectionModel
    private var nfts: [NftModel] = []
    private var profile: ProfileModel = ProfileModel(name: "", website: "", likes: [])
    private var order: OrderModel = OrderModel(nfts: [])
    
    private enum Const {
        static let cellMargins: CGFloat = 9
        static let lineMargins: CGFloat = 8
        static let cellCols: CGFloat = 3
        static let cellHeight: CGFloat = 192
        static let sideMargins: CGFloat = 16
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()
    
    private lazy var coverImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline2
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var authorTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nftBlack
        label.text = NSLocalizedString("Collection.AuthorLabel", comment: "")
        return label
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nftBlueUniversal
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nftBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    init(collectionViewModel: CollectionViewModel, collection: CollectionModel) {
        self.collectionViewModel = collectionViewModel
        self.collection = collection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupNavigationBar()
        setupViews()
        collectionViewModel.load(nftIds: collection.nfts)
    }
    
    private func bindViewModel() {
        let bindings = CollectionViewModelBindings(
            isLoading: { [weak self] in
                guard let self else { return }
                if $0 {
                    ProgressHUD.show()
                } else {
                    ProgressHUD.dismiss()
                }
            },
            nfts: { [weak self] in
                guard let self else { return }
                self.nfts = $0
                self.collectionView.reloadData()
            },
            profile: { [weak self] in
                guard let self else { return }
                self.profile = $0
                self.authorNameLabel.text = self.profile.name
            },
            order: { [weak self] in
                guard let self else { return }
                self.order = $0
            }
        )
        collectionViewModel.bind(bindings)
    }
    
    private func setupNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .nftBlack
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
    
    private func setupViews() {
        view.backgroundColor = .nftWhite
        setupScrollView()
        [coverImage, nameLabel, authorTitleLabel,
         authorNameLabel, descriptionLabel, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        setupCoverImage()
        setupNameLabel()
        setupAuthorTitleLabel()
        setupAuthorNameLabel()
        setupDescriptionLabel()
        setupCollectionView()
        
        let collectionHeight = (Const.cellHeight + Const.lineMargins) * ceil(CGFloat(collection.nfts.count) / Const.cellCols)
        collectionView.heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
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
        scrollView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.sideMargins)
        ])
    }
    
    private func setupAuthorTitleLabel() {
        NSLayoutConstraint.activate([
            authorTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            authorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.sideMargins)
        ])
    }
    
    private func setupAuthorNameLabel() {
        authorNameLabel.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapUserNameLabel(_:)))
        authorNameLabel.addGestureRecognizer(guestureRecognizer)
        NSLayoutConstraint.activate([
            authorNameLabel.topAnchor.constraint(equalTo: authorTitleLabel.topAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorTitleLabel.trailingAnchor, constant: 4)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = collection.description
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.sideMargins),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Const.sideMargins)
        ])
    }
    
    @objc
    func didTapUserNameLabel(_ sender: Any) {
        let webViewController = WebViewController(profile.website)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func setupCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.sideMargins),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Const.sideMargins),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.identifier,
            for: indexPath
        ) as? CollectionViewCell else {
            assertionFailure("Error get cell")
            return .init()
        }
        cell.configure(nft: nfts[indexPath.row],
                       likes: profile.likes,
                       order: order.nfts,
                       onReversLike: collectionViewModel.reversLike(nftId:),
                       onReversCart: collectionViewModel.reversCart(nftId:))
        collectionViewCell = cell
        return collectionViewCell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = floor((collectionView.frame.width - Const.cellMargins * (Const.cellCols - 1)) / Const.cellCols)
            return CGSize(width: width, height: Const.cellHeight)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return Const.cellMargins
        }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.lineMargins
    }
}
