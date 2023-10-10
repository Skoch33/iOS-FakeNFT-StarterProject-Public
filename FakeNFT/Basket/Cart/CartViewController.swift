import UIKit

final class CartViewController: UIViewController {

    private let layoutMargin = CGFloat(16)
    private lazy var nftCountLabel = createCountLabel()
    private lazy var nftPriceTotalLabel = createPriceTotalLabel()

    private var nftCount: Int { 1 }
    private var nftPriceTotal: Decimal { 0.0 }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @objc private func payButtonDidTap() {

    }
}

// MARK: UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartViewCell.reuseId,
            for: indexPath
        ) as? CartViewCell
        else { return UITableViewCell() }

        // mock для проверки верстки ячейки
        cell.rating = 2
        cell.nftPrice = 6.59
        cell.nftName = "Rosie"
        cell.delegate = self
        cell.nftID = "93"
        cell.nftImageURL = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Rosie/1.png")
        return cell
    }
}

// MARK: CartCellDelegate
extension CartViewController: CartCellDelegate {
    func deleteButtonDidTap(nftID: String) {
        print("delete \(nftID)")
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

        let tableView = createTableView()
        view.addSubview(tableView)

        let paymentView = createPaymentView()
        view.addSubview(paymentView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: paymentView.topAnchor),

            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentView.heightAnchor.constraint(equalToConstant: 76)
        ])
    }

    func createTableView() -> UITableView {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(CartViewCell.self, forCellReuseIdentifier: CartViewCell.reuseId)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
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
        let nftCountLabel = UILabel()
        nftCountLabel.text = "\(nftCount) NFT"
        nftCountLabel.font = .caption1
        nftCountLabel.textColor = .nftBlack
        nftCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return nftCountLabel
    }

    func createPriceTotalLabel() -> UILabel {
        let nftPriceTotalLabel = UILabel()
        nftPriceTotalLabel.text = PriceFormatter.formattedPrice(nftPriceTotal)
        nftPriceTotalLabel.font = .bodyBold
        nftPriceTotalLabel.textColor = .nftGreenUniversal
        nftPriceTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        return nftPriceTotalLabel
    }
}
