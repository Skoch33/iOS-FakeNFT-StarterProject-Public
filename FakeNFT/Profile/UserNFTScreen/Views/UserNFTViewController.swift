import UIKit

final class UserNFTViewController: UIViewController {
    
    // MARK: - UI properties
    
    private lazy var alertService: AlertServiceProtocolProfile = {
        return AlertService(viewController: self)
    }()
    
    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NFTCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .nftWhite
        return tableView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var noNFTLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("UserNFTViewController.nonft", comment: "")
        label.font = .NftBodyFonts.bold
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    
    private let nftList: [String]
    private let viewModel: UserNFTViewModelProtocol
    
    // MARK: - Lifecycle
    
    init(nftList: [String], viewModel: UserNFTViewModelProtocol) {
        self.nftList = nftList
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad(nftList: self.nftList)
        setupViews()
        configNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    
    // MARK: - Actions
    
    @objc
    private func sortButtonTapped() {
        let priceAction = AlertActionModelProfile(title: SortOption.price.description, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.userSelectedSorting(by: .price)
        }
        
        let ratingAction = AlertActionModelProfile(title: SortOption.rating.description, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.userSelectedSorting(by: .rating)
        }
        
        let titleAction = AlertActionModelProfile(title: SortOption.title.description, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.userSelectedSorting(by: .title)
        }
        
        let cancelAction = AlertActionModelProfile(title: NSLocalizedString("AlertAction.close", comment: ""),
                                            style: .cancel,
                                            handler: nil)
        
        let alertModel = AlertModelProfile(title: NSLocalizedString("AlertAction.sort", comment: ""),
                                    message: nil,
                                    style: .actionSheet,
                                    actions: [priceAction, ratingAction, titleAction, cancelAction],
                                    textFieldPlaceholder: nil)
        
        alertService.showAlert(model: alertModel)
    }
    
    // MARK: - Methods
    
    private func sortData(by option: SortOption) {
        viewModel.userSelectedSorting(by: option)
    }
    
    private func bind() {
        viewModel.observeUserNFT { [weak self] _ in
            guard let self = self else { return }
            self.nftTableView.reloadData()
        }
        
        viewModel.observeState { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.setUIInteraction(false)
            case .loaded(let hasData):
                if hasData {
                    self.updateUIBasedOnNFTData()
                } else {
                    self.noNFTLabel.isHidden = false
                }
            case .error(_):
                print("Ошибка")
            default:
                break
            }
        }
    }
    
    private func updateUIBasedOnNFTData() {
        let barButtonItem = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.title = NSLocalizedString("ProfileViewController.myNFT", comment: "")
        setUIInteraction(true)
    }
    
    private func setUIInteraction(_ enabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.leftBarButtonItem?.isEnabled = enabled
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .nftWhite

        [nftTableView, noNFTLabel].forEach { view.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            nftTableView .topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configNavigationBar() {
        setupCustomBackButton()
    }
}

// MARK: - UITableViewDataSource

extension UserNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.userNFT?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NFTCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        
        guard let nft = viewModel.userNFT?[indexPath.row] else {
            return cell
        }
        
        if let author = viewModel.authors[nft.author] {
            cell.configure(nft: nft, authorName: author.name)
        } else {
            cell.configure(nft: nft, authorName: "Unknown author")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .nftWhite
    }
}

// MARK: - UITableViewDelegate

extension UserNFTViewController: UITableViewDelegate {
    
}
