//
//  SelectCurrencyViewController.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 19.10.2023.
//

import UIKit
import ProgressHUD

final class SelectCurrencyViewController: UIViewController {

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

    private var currencyList: [CartCurrency] = []
    private var numberOfCurrencies: Int { currencyList.count }
    private lazy var currencyCollectionView = createCurrencyCollectionView()
    private lazy var payButton = createPayButton()

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

    @objc private func pullToRefreshDidTrigger() {
        viewModel?.pullToRefreshDidTrigger()
    }

    private func bindViewModel() {
        viewModel?.bind(SelectCurrencyViewModelBindings(
            currencyList: { [ weak self ] in
                guard let self else { return }
                self.currencyList = $0
                self.currencyCollectionView.reloadData()
                self.currencyCollectionView.refreshControl?.endRefreshing()
                ProgressHUD.dismiss()
            },
            isViewDismissing: { [ weak self ] in
                if $0 {
                    self?.navigationController?.popViewController(animated: true)
                }
            },
            isAgreementDisplaying: { [ weak self ] in
                if $0 {
                    self?.presentAgreement()
                }
            },
            isNetworkAlertDisplaying: { [ weak self ] in
                guard let self else { return }
                self.currencyCollectionView.refreshControl?.endRefreshing()
                ProgressHUD.dismiss()
                if $0 {
                    self.displayNetworkAlert()
                }
            },
            isPaymentResultDisplaying: { [ weak self ] in
                guard let isPaymentSuccessful = $0 else { return }
                self?.presentPaymentResult(isPaymentSuccessful)
            },
            isCurrencyDidSelect: { [ weak self ] in
                self?.payButton.isEnabled = $0
            })
        )
    }

    private func presentAgreement() {

    }

    private func presentPaymentResult(_ success: Bool) {
        if success {
            let viewModel = SuccessfulPaymentViewModel()
            let controller = SuccessfulPaymentViewController(viewModel: viewModel)
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        } else {
            guard let viewModel else { return }
            let alertController = DefaultAlertService(delegate: viewModel, controller: self)
            alertController.presentSomethingWrongAlert()
        }
    }

    private func displayNetworkAlert() {
        guard let viewModel else { return }
        let alertService = DefaultAlertService(delegate: viewModel, controller: self)
        alertService.presentNetworkErrorAlert()
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

        let currency = currencyList[indexPath.item]
        cell.viewModel = CurrencyCellViewModel()
        cell.viewModel?.cellReused(for: currency)
        return cell
    }
}

extension SelectCurrencyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCurrency = currencyList[indexPath.item].id
        viewModel?.didSelectCurrency(selectedCurrency)
    }
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
        setupProgress()
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
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefreshDidTrigger), for: .valueChanged)
        collection.refreshControl = refreshControl
        collection.backgroundColor = .nftWhite
        collection.register(CurrencyViewCell.self)
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }

    private func createPayButton() -> RoundedButton {
        let button = RoundedButton(title: "SelectCurrencyViewController.paymentView.buttonTitle".localized())
        button.isEnabled = false
        button.addTarget(self, action: #selector(payButtonDidTap), for: .touchUpInside)
        return button
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
        view.addSubview(payButton)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.collectionLeftMargin),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.collectionLeftMargin),

            link.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.collectionLeftMargin),
            link.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),

            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.collectionLeftMargin),
            payButton.topAnchor.constraint(equalTo: link.bottomAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.collectionLeftMargin),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        return view
    }

    func setupProgress() {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorHUD = .nftBlack
        ProgressHUD.colorAnimation = .nftLightgrey
        ProgressHUD.show()
    }
}
