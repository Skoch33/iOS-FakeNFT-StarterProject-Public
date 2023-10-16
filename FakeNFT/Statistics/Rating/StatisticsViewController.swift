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
    
    init(viewModel: StatisticsViewModelProtocol = StatisticsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        let sortByNameButton = AlertActionModel(
            title: "По имени",
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sortUsersByName()
        }
        
        let sortByRatingButton = AlertActionModel(
            title: "По рейтингу",
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sortUsersByRating()
        }
        
        let closeButton = AlertActionModel(
            title: "Закрыть",
            style: .cancel
        )

        let alertModel = AlertPresenter(
            title: "Сортировка",
            actions: [sortByNameButton, sortByRatingButton, closeButton],
            style: .actionSheet
        )

        alertModel.showAlert(from: self)
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
            image: UIImage(named: "SortIcon"),
            style: .plain,
            target: self,
            action: #selector(sortingUsers)
        )
        
        filterButton.tintColor = UIColor.nftBlack
        navigationItem.rightBarButtonItem = filterButton
    }
    
    private func bind() {
        viewModel.showError = { [weak self] _ in
            self?.showNetworkError(message: "Не удалось получить данные")
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

    private func showNetworkError(message: String) {
        let retryButton = AlertActionModel(
            title: "Повторить",
            style: .cancel,
            handler: {  [weak self] _ in
            self?.viewModel.loadData()
        })

        let closeButton = AlertActionModel(
            title: "Отмена",
            style: .default
        )

        let alertModel = AlertPresenter(
            message: message,
            actions: [retryButton, closeButton],
            style: .alert
        )

        alertModel.showAlert(from: self)
    }
}
// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
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
