import UIKit
import ProgressHUD

protocol DeleteNftDelegate: AnyObject {
    func deleteNftDidApprove(for id: String)
}

final class CartViewController: UIViewController {

    var viewModel: CartViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }
    private let layoutMargin: CGFloat = 16
    private lazy var alertService = createAlertService()
    private lazy var nftCountLabel = createCountLabel()
    private lazy var nftPriceTotalLabel = createPriceTotalLabel()
    private lazy var nftCartTableView = createTableView()
    private lazy var nftPaymentView = createPaymentView()
    private lazy var emptyCartPlaceholderView = createEmptyCartPlaceholder()

    private var nftCount: Int = .zero
    private var nftPriceTotal: Decimal = .zero
    private var nftList: [CartNftInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel?.viewDidLoad()
    }

    @objc private func payButtonDidTap() {
        viewModel?.payButtonDidTap()
    }

    @objc private func sortButtonDidTap() {
        presentSortViewController()
    }

    @objc private func pullToRefreshDidTrigger() {
        viewModel?.pullToRefreshDidTrigger()
    }

    private func bindViewModel() {
        let numberOfNftBinding = { [weak self] in
            guard let self else { return }
            self.nftCount = $0
            self.displayNftCount()
        }
        let priceTotalBinding = { [weak self] in
            guard let self else { return }
            self.nftPriceTotal = $0
            self.displayPriceTotal()
        }
        let nftListBinding = { [weak self] in
            guard let self else { return }
            self.nftList = $0
            self.nftCartTableView.reloadData()
            if self.nftCartTableView.refreshControl?.isRefreshing == true {
                self.nftCartTableView.refreshControl?.endRefreshing()
            }
            ProgressHUD.dismiss()
        }
        let networkAlertDisplayBinding = { [weak self] isNetworkAlertDisplaying in
            guard let self else { return }
            if isNetworkAlertDisplaying {
                ProgressHUD.dismiss()
                if self.nftCartTableView.refreshControl?.isRefreshing == true {
                    self.nftCartTableView.refreshControl?.endRefreshing()
                }
                self.alertService?.presentNetworkErrorAlert()
            }
        }
        let paymentScreenDisplayBinding = { [weak self] isPaymentScreenDisplaying in
            if isPaymentScreenDisplaying {
                self?.presentPaymentViewController()
            }
        }
        let bindings = CartViewModelBindings(
            numberOfNft: numberOfNftBinding,
            priceTotal: priceTotalBinding,
            nftList: nftListBinding,
            isEmptyCartPlaceholderDisplaying: { [weak self] in
                self?.displayEmptyCartPlaceholder($0)
            },
            isNetworkAlertDisplaying: networkAlertDisplayBinding,
            isPaymentScreenDisplaying: paymentScreenDisplayBinding
        )
        viewModel?.bind(bindings)
    }

    private func backToCartViewController() {
        viewModel?.didGetBackToCart()
    }

    private func presentPaymentViewController() {
        let paymentController = SelectCurrencyViewController()
        let currencyDataProvider = CartCurrencyDataProvider()
        let viewModel = SelectCurrencyViewModel(dataProvider: currencyDataProvider)
        paymentController.viewModel = viewModel
        paymentController.onBackToCartViewController = backToCartViewController
        paymentController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(paymentController, animated: true)
    }

    private func displayEmptyCartPlaceholder(_ isPlaceHolderVisible: Bool) {
        emptyCartPlaceholderView.isHidden = !isPlaceHolderVisible
        nftCartTableView.isHidden = isPlaceHolderVisible
        nftPaymentView.isHidden = isPlaceHolderVisible
        navigationController?.isNavigationBarHidden = isPlaceHolderVisible
    }

    private func presentSortViewController() {

        let title = "CartViewController.SortAlert.title".localized()
        let priceItemTitle = "CartViewController.SortAlert.byPrice".localized()
        let ratingItemTitle = "CartViewController.SortAlert.byRating".localized()
        let nameItemTitle = "CartViewController.SortAlert.byName".localized()
        let cancelItemTitle = "CartViewController.SortAlert.cancel".localized()

        let alertController = CartAlertController(
            delegate: self,
            title: title,
            actions: [
                CartAlertAction(title: priceItemTitle) { [weak self] _ in
                    self?.viewModel?.sortOrderDidChange(to: .byPrice)
                },
                CartAlertAction(title: ratingItemTitle) { [weak self] _ in
                    self?.viewModel?.sortOrderDidChange(to: .byRating)
                },
                CartAlertAction(title: nameItemTitle) { [weak self] _ in
                    self?.viewModel?.sortOrderDidChange(to: .byName)
                },
                CartAlertAction(title: cancelItemTitle, style: .cancel)
            ],
            style: .actionSheet)

        alertController.show()
    }

    private func createAlertService() -> AlertServiceProtocol? {
        guard let viewModel else { return nil }
        let alertService = DefaultAlertService(delegate: viewModel, controller: self)
        return alertService
    }
}

// MARK: UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nftCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartViewCell = tableView.dequeueReusableCell()

        let nft = nftList[indexPath.item]
        cell.viewModel = CartCellViewModel(delegate: self, nftId: nft.id)
        cell.viewModel?.cellReused(for: nft)
        return cell
    }
}

// MARK: CartCellDelegate
extension CartViewController: CartCellDelegate {
    func deleteButtonDidTap(for nftId: String, with image: Any?, imageURL: URL?) {
        let viewModel = DeleteNftViewModel(delegate: self, nftId: nftId)
        let controller = DeleteNftViewController(viewModel: viewModel, image: image as? UIImage, imageURL: imageURL)
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true)
    }
}

extension CartViewController: DeleteNftDelegate {
    func deleteNftDidApprove(for id: String) {
        viewModel?.deleteNftDidApprove(for: id)
    }
}

// MARK: UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            guard let cell = tableView.cellForRow(at: indexPath) as? CartViewCell else { return }
            cell.viewModel?.deleteButtonDidTap(image: nil)
        }
    }
}

// MARK: Setup UI & Layout
private extension CartViewController {
    func setupUI() {
        view.backgroundColor = .nftWhite
        setupProgress()

        let sortButton = UIBarButtonItem(
            image: UIImage(named: "action_sort") ?? UIImage(),
            style: .plain,
            target: self,
            action: #selector(sortButtonDidTap)
        )
        sortButton.tintColor = .nftBlack
        navigationItem.rightBarButtonItem = sortButton

        view.addSubview(nftCartTableView)
        view.addSubview(nftPaymentView)
        displayNftCount()
        displayPriceTotal()

        NSLayoutConstraint.activate([
            nftCartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftCartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCartTableView.bottomAnchor.constraint(equalTo: nftPaymentView.topAnchor),

            nftPaymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftPaymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftPaymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftPaymentView.heightAnchor.constraint(equalToConstant: 76)
        ])

        view.addSubview(emptyCartPlaceholderView)
        NSLayoutConstraint.activate([
            emptyCartPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        displayEmptyCartPlaceholder(true)
    }

    func setupProgress() {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorHUD = .nftBlack
        ProgressHUD.colorAnimation = .nftLightgrey
        ProgressHUD.show()
    }

    func createTableView() -> UITableView {
        let table = UITableView()
        table.separatorStyle = .none
        table.allowsSelection = false
        table.backgroundColor = .nftWhite
        table.delegate = self
        table.dataSource = self
        table.register(CartViewCell.self)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefreshDidTrigger), for: .valueChanged)
        table.refreshControl = refreshControl
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }

    func displayPriceTotal() {
        nftPriceTotalLabel.text = PriceFormatter.formattedPrice(nftPriceTotal)
    }

    func displayNftCount() {
        nftCountLabel.text = "\(nftCount) NFT"
    }

    func createPaymentView() -> UIView {
        let view = UIView()
        view.backgroundColor = .nftLightgrey
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false

        let labelView = UIStackView(arrangedSubviews: [nftCountLabel, nftPriceTotalLabel])
        labelView.axis = .vertical
        labelView.alignment = .leading
        labelView.spacing = 2
        labelView.distribution = .fillEqually
        labelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelView)

        let button = RoundedButton(
            title: NSLocalizedString("CartViewController.paymentButtonTitle", comment: "")
        )
        button.addTarget(self, action: #selector(payButtonDidTap), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: layoutMargin),
            labelView.topAnchor.constraint(equalTo: view.topAnchor, constant: layoutMargin),
            labelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -layoutMargin),

            button.widthAnchor.constraint(equalToConstant: 240),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: layoutMargin),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -layoutMargin),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -layoutMargin)
        ])
        return view
    }

    func createCountLabel() -> UILabel {
        let label = UILabel()
        label.font = .NftCaptionFonts.large
        label.textColor = .nftBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createPriceTotalLabel() -> UILabel {
        let label = UILabel()
        label.font = .NftBodyFonts.bold
        label.textColor = .nftGreenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createEmptyCartPlaceholder() -> UIView {
        let view = UILabel()
        view.text = NSLocalizedString("CartViewController.emptyCartPlaceholderText", comment: "")
        view.font = .NftBodyFonts.bold
        view.textColor = .nftBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
