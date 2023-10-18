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
        // TODO: реализовать оплату
    }

    @objc private func sortButtonDidTap() {
        let alertController = createAlertController()
        present(alertController, animated: true)
    }

    @objc private func pullToRefreshDidTrigger() {
        viewModel?.pullToRefreshDidTrigger()
    }

    private func bindViewModel() {
        let bindings = CartViewModelBindings(
            numberOfNft: { [weak self] in
                guard let self else { return }
                self.nftCount = $0
                self.displayNftCount()
            },
            priceTotal: { [weak self] in
                guard let self else { return }
                self.nftPriceTotal = $0
                self.displayPriceTotal()
            },
            nftList: { [weak self] in
                guard let self else { return }
                self.nftList = $0
                self.nftCartTableView.reloadData()
                if nftCartTableView.refreshControl?.isRefreshing == true {
                    nftCartTableView.refreshControl?.endRefreshing()
                }
                ProgressHUD.dismiss()
            },
            isEmptyCartPlaceholderDisplaying: { [weak self] in
                self?.displayEmptyCartPlaceholder($0)
            }
        )
        viewModel?.bind(bindings)
    }

    private func displayEmptyCartPlaceholder(_ isPlaceHolderVisible: Bool) {
        emptyCartPlaceholderView.isHidden = !isPlaceHolderVisible
        nftCartTableView.isHidden = isPlaceHolderVisible
        nftPaymentView.isHidden = isPlaceHolderVisible
        navigationController?.isNavigationBarHidden = isPlaceHolderVisible
    }

    private func createAlertController() -> UIAlertController {
        let title = NSLocalizedString("CartViewController.SortAlert.title", comment: "")
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        let priceItemTitle = NSLocalizedString("CartViewController.SortAlert.byPrice", comment: "")
        let priceItem = UIAlertAction(title: priceItemTitle, style: .default) { [weak self] _ in
            self?.viewModel?.sortOrderDidChange(to: .byPrice)
        }
        controller.addAction(priceItem)

        let ratingItemTitle = NSLocalizedString("CartViewController.SortAlert.byRating", comment: "")
        let ratingItem = UIAlertAction(title: ratingItemTitle, style: .default) { [weak self] _ in
            self?.viewModel?.sortOrderDidChange(to: .byRating)
        }
        controller.addAction(ratingItem)

        let nameItemTitle = NSLocalizedString("CartViewController.SortAlert.byName", comment: "")
        let nameItem = UIAlertAction(title: nameItemTitle, style: .default) { [weak self] _ in
            self?.viewModel?.sortOrderDidChange(to: .byName)
        }
        controller.addAction(nameItem)

        let cancelItemTitle = NSLocalizedString("CartViewController.SortAlert.cancel", comment: "")
        let cancel = UIAlertAction(title: cancelItemTitle, style: .cancel)
        controller.addAction(cancel)

        return controller
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
