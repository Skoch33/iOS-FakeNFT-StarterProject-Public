//
//  SelectCurrencyViewController.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 19.10.2023.
//

import UIKit

class SelectCurrencyViewController: UIViewController {

    private enum Constants {
        static let cellInterimSpacing: CGFloat = 7
        static let cellLineSpacing: CGFloat = 7
        static let cellHeight: CGFloat = 46
        static let cellsInRow: Int = 2
        static let collectionLeftMargin: CGFloat = 16
        static let collectionTopMargin: CGFloat = 20
        static let paymentViewHeight: CGFloat = 186
    }

    var viewModel: SelectCurrencyViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }

    private var numberOfCurrencies: Int { 50 }
    private lazy var currencyCollectionView = createCurrencyCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        viewModel?.viewDidLoad()
    }

    @objc private func backButtonDidTap() {
        viewModel?.backButtonDidTap()
    }

    @objc private func userAgreementDidTap() {
        viewModel?.userAgreementDidTap()
    }

    @objc private func payButtonDidTap() {
        viewModel?.payButtonDidTap()
    }

    private func bindViewModel() {
        // TODO: написать биндинг viewModel'и
    }
}

extension SelectCurrencyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfCurrencies
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: CurrencyViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.imageURL = URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Bitcoin_(BTC).png")
        cell.currencyName = "Bitcoin"
        cell.currencyCode = "BTC"
        return cell
    }
}

extension SelectCurrencyViewController: UICollectionViewDelegateFlowLayout {

}

// MARK: Setup & Layout UI
private extension SelectCurrencyViewController {
    func setupUI() {
        view.backgroundColor = .nftWhite

        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        backButton.tintColor = .nftBlack
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "SelectCurrencyViewController.navigationItem.title".localized()
        navigationItem.titleView?.tintColor = .nftBlack

        view.addSubview(currencyCollectionView)

        let paymentView = createPaymentView()
        view.addSubview(paymentView)

        NSLayoutConstraint.activate([
            currencyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currencyCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paymentView.heightAnchor.constraint(equalToConstant: Constants.paymentViewHeight)
        ])
    }

    func createCurrencyCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.cellInterimSpacing
        layout.minimumLineSpacing = Constants.cellLineSpacing
        layout.sectionInset = UIEdgeInsets(
            top: Constants.collectionTopMargin,
            left: Constants.collectionLeftMargin,
            bottom: Constants.collectionTopMargin,
            right: Constants.collectionLeftMargin
        )
        let rowEmptySpace = Constants.collectionLeftMargin * CGFloat(2) + Constants.cellInterimSpacing
        let cellWidth = (view.bounds.width - rowEmptySpace) / CGFloat(Constants.cellsInRow)
        layout.itemSize = CGSize(width: cellWidth, height: Constants.cellHeight)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .nftWhite
        collection.register(CurrencyViewCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }

    func createPaymentView() -> UIView {
        let view = UIView()
        view.backgroundColor = .nftLightgrey
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.font = .NftCaptionFonts.medium
        label.textColor = .nftBlack
        label.textAlignment = .left
        label.text = "SelectCurrencyViewController.paymentView.agreementLabel".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        let link = UIButton()
        link.setTitle("SelectCurrencyViewController.paymentView.agreementLink".localized(), for: .normal)
        link.setTitleColor(.nftBlueUniversal, for: .normal)
        link.titleLabel?.font = .NftCaptionFonts.medium
        link.titleLabel?.textAlignment = .left
        link.addTarget(self, action: #selector(userAgreementDidTap), for: .touchUpInside)
        link.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(link)

        let button = RoundedButton(title: "SelectCurrencyViewController.paymentView.buttonTitle".localized())
        button.addTarget(self, action: #selector(payButtonDidTap), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.collectionLeftMargin),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.collectionLeftMargin),

            link.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.collectionLeftMargin),
            link.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),

            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.collectionLeftMargin),
            button.topAnchor.constraint(equalTo: link.bottomAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.collectionLeftMargin),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return view
    }
}
