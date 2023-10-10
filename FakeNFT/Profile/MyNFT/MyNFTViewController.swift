//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Semen Kocherga on 10.10.2023.
//

import UIKit

class MyNFTViewController: UIViewController {

    let mockNFTData: [MyNFTCellViewModel] = [
        (MyNFTCellViewModel(nftImage: UIImage(named: "NFTcard") ?? UIImage(), nftName: "Spring", nftRateImage: UIImage(named: "rating") ?? UIImage(), nftFromName: "от John Doe", nftPrice: "1,55")),
        (MyNFTCellViewModel(nftImage: UIImage(named: "NFTcard") ?? UIImage(), nftName: "Spring", nftRateImage: UIImage(named: "rating") ?? UIImage(), nftFromName: "от John Doe", nftPrice: "1,99")),
        (MyNFTCellViewModel(nftImage: UIImage(named: "NFTcard") ?? UIImage(), nftName: "Spring", nftRateImage: UIImage(named: "rating") ?? UIImage(), nftFromName: "от John Doe", nftPrice: "1,24")),
        (MyNFTCellViewModel(nftImage: UIImage(named: "NFTcard") ?? UIImage(), nftName: "Spring", nftRateImage: UIImage(named: "rating") ?? UIImage(), nftFromName: "от John Doe", nftPrice: "1,52")),
        (MyNFTCellViewModel(nftImage: UIImage(named: "NFTcard") ?? UIImage(), nftName: "Spring", nftRateImage: UIImage(named: "rating") ?? UIImage(), nftFromName: "от John Doe", nftPrice: "1,11"))
    ]
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        view.backgroundColor = .nftWhite
        view.tintColor = .nftBlack
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backward"), style: .plain, target: self, action: #selector(goBackButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .nftBlack
        title = (NSLocalizedString("MyNFTViewController.mynft", comment: ""))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .nftBlack
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyNFTCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViews() {
           view.setupView(collectionView)
       }

    // MARK: - Actions
    
    @objc private func goBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sortButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate&UICollectionViewDataSource

extension MyNFTViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockNFTData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.setupCellData(mockNFTData[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 108)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}
