import UIKit

final class CartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartViewCell.reuseIdentifier,
            for: indexPath
        ) as? CartViewCell
        else { return UITableViewCell() }

        return cell
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
        paymentView.backgroundColor = .nftLightgrey
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
        table.register(CartViewCell.self, forCellReuseIdentifier: CartViewCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }

    func createPaymentView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
