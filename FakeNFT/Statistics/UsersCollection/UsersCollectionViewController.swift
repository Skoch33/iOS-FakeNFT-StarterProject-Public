//
//  UsersCollectionViewController.swift
//  FakeNFT
//

import UIKit
import ProgressHUD

final class UserCollectionViewController: UIViewController {
    // MARK: - SubView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            UsersCollectionCell.self,
            forCellWithReuseIdentifier: UsersCollectionCell.identifier
        )
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .nftWhite
        return collectionView
    }()
    // MARK: - ViewModel
    private let viewModel: UsersCollectionViewModelProtocol
    private var alert: NetworkAlert?

    init(viewModel: UsersCollectionViewModelProtocol = UsersCollectionViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        alert = NetworkAlert(delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        bind()
        viewModel.viewDidLoad()
    }
    // MARK: - Setup Views
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil,
                                                        action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        navigationController?.navigationBar.tintColor = .nftBlack
    }

    private func setupCollectionView() {
        view.backgroundColor = .nftWhite
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    // MARK: - bind
    private func bind() {
        viewModel.isDataLoading = { isLoading in
            isLoading ? ProgressHUD.show() : ProgressHUD.dismiss()
        }

        viewModel.dataChanged = { [weak self] in
            self?.collectionView.reloadData()
        }

        viewModel.showNetworkError = { [weak self] _ in
            self?.showNetworkError("Не все NFT удалось загрузить")
        }
    }
    // MARK: - NetworkErrorAlert
    private func showNetworkError(_ message: String) {
        let alertModel = AlertModel(
            message: message,
            style: .alert) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.viewDidLoad()
            }
        alert?.showAlert(alertModel)
    }
}
// MARK: - UICollectionViewDataSource
extension UserCollectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.nftCount()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UsersCollectionCell.identifier,
            for: indexPath
        ) as? UsersCollectionCell else { return UICollectionViewCell()}

        let nft = viewModel.nfts[indexPath.row]
        let rating = nft.rating
        let isLiked = viewModel.isLikedNFT(at: indexPath.row)
        cell.configure(nft: nft, rating: rating, isLiked: isLiked)
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension UserCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 108, height: 192)
    }
}
// MARK: - NetworkAlert
extension UserCollectionViewController: NetworkAlertDelegate {
    func presentNetworkAlert(_ alertController: UIAlertController) {
        self.present(alertController, animated: true)
    }
}
