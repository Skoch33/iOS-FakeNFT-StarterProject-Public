import UIKit
import ProgressHUD

final class CatalogViewController: UIViewController {
    
    var catalogViewModel: CatalogViewModelProtocol
    private var collections: [CollectionModel] = []
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        
        view.register(CatalogCell.self,
                      forCellReuseIdentifier: CatalogCell.identifier)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    init(catalogViewModel: CatalogViewModel) {
        self.catalogViewModel = catalogViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .nftWhite
        
        setupNavigationBar()
        setupTableView()
        
        bindViewModel()
        catalogViewModel.loadCollection()
    }
    
    private func bindViewModel() {
        let bindings = CatalogViewModelBindings(
            isLoading: {
                if $0 {
                    ProgressHUD.show()
                } else {
                    ProgressHUD.dismiss()
                }
            },
            collections: { [weak self] in
                guard let self else { return }
                self.collections = $0
                self.tableView.reloadData()
            },
            isError: { [weak self] in
                guard let self else { return }
                if $0 {
                    AlertWithRetryAction().show(view: self, 
                                                title: NSLocalizedString("Catalog.ErrorAlertLoad", comment: ""),
                                                action: { self.catalogViewModel.loadCollection()
                    })
                }
            }
        )
        catalogViewModel.bind(bindings)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            let imageButton = UIImage(named: "Catalog.sortButton")?.withRenderingMode(.alwaysTemplate)
            
            let rightItem = UIBarButtonItem(image: imageButton,
                                            style: .plain,
                                            target: self,
                                            action: #selector(selectingSortMode))
            rightItem.tintColor = .nftBlack
            navigationBar.topItem?.setRightBarButton(rightItem, animated: false)
        }
    }
    
    @objc
    private func selectingSortMode() {
        let alertController = UIAlertController(
            title: NSLocalizedString("Catalog.Sorting.Title", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        CatalogSortingModes.allCases.forEach {sortingMode in
            let sortingAction = UIAlertAction(
                title: sortingMode.title,
                style: .default
            ) { [weak self] _ in
                self?.catalogViewModel.sort(sortingMode)
                self?.tableView.reloadData()
            }
            alertController.addAction(sortingAction)
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Catalog.Sorting.Close", comment: ""),
            style: .cancel
        )
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.collections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.identifier,
                                                       for: indexPath) as? CatalogCell
        else { return UITableViewCell() }
        cell.config(self.collections[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionViewModel = CollectionViewModel(networkClient: DefaultNetworkClient(), collection: self.collections[indexPath.row])
        let collectionViewController = CollectionViewController(collectionViewModel: collectionViewModel)
        navigationController?.pushViewController(collectionViewController, animated: true)
    }
}
