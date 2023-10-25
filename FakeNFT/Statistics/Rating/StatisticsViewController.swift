//
//  RatingViewController.swift
//  FakeNFT
//

import UIKit
import ProgressHUD

final class StatisticsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.register(
            StatisticsCell.self,
            forCellReuseIdentifier: StatisticsCell.identifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .nftWhite
        tableView.separatorStyle = .none
        return tableView
    }()

    private let viewModel: StatisticsViewModelProtocol
    private var alert: NetworkAlert?

    init(viewModel: StatisticsViewModelProtocol = StatisticsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        alert = NetworkAlert(delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
// MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bind()
        viewModel.loadData()
    }
// MARK: - Action
    @objc
    private func sortingUsers() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet)

        let sortByNameButton = UIAlertAction(
            title: "По имени",
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sortUsersByName()
        }

        let sortByRatingButton = UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sortUsersByRating()
        }

        let closeButton = UIAlertAction(
            title: "Закрыть",
            style: .cancel
        )

        [sortByNameButton, sortByRatingButton, closeButton].forEach {
            alert.addAction($0)
        }

        present(alert, animated: true)
    }
// MARK: - Setup
    private func setupUI() {
        view.addSubview(tableView)
        view.backgroundColor = .nftWhite

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(
            image: .sortIcon,
            style: .plain,
            target: self,
            action: #selector(sortingUsers)
        )

        filterButton.tintColor = UIColor.nftBlack
        navigationItem.rightBarButtonItem = filterButton
    }

    private func bind() {
        viewModel.showError = { [weak self] _ in
            self?.showNetworkError("Не удалось получить данные")
        }

        viewModel.isDataLoading = { isLoading in
            if isLoading {
                ProgressHUD.show()
            } else {
                ProgressHUD.dismiss()
            }
        }

        viewModel.dataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func showNetworkError(_ message: String) {
        let alertModel = AlertModel(
            message: message,
            style: .alert) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.loadData()
            }
        alert?.showAlert(alertModel)
    }
}
// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsCell.identifier,
            for: indexPath
        ) as? StatisticsCell else { return UITableViewCell() }

        let user = viewModel.users[indexPath.row]
        cell.configure(model: user)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userCardViewModel = UserCardViewModel()
        userCardViewModel.user = viewModel.users[indexPath.row]
        let userCard = UserCardViewController(viewModel: userCardViewModel)
        navigationController?.pushViewController(userCard, animated: true)
    }
}
// MARK: - NetworkAlert
extension StatisticsViewController: NetworkAlertDelegate {
    func presentNetworkAlert(_ alertController: UIAlertController) {
        self.present(alertController, animated: true)
    }
}
