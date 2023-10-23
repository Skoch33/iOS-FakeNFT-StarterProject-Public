//
//  AgreementViewController.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 23.10.2023.
//

import UIKit
import WebKit

final class AgreementViewController: UIViewController {
    static let agreementURLString: String = "https://yandex.ru/legal/practicum_termsofuse/"
    private var viewModel: AgreementViewModelProtocol
    private lazy var webView = createWebView()

    init(viewModel: AgreementViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.bind(AgreementViewModelBindings(
            isViewDismissing: { [ weak self ] in
                if $0 {
                    self?.navigationController?.popViewController(animated: true)
                }
            },
            isWebViewLoading: { [ weak self ] in
                if $0 {
                    guard let url = URL(string: Self.agreementURLString) else { return }
                    let request = URLRequest(url: url)
                    self?.webView.load(request)
                }
            })
        )
        viewModel.viewDidLoad()
    }

    @objc private func backButtonDidTap() {
        viewModel.backButtonDidTap()
    }
}

extension AgreementViewController: WKNavigationDelegate {

}

// MARK: Setup & Layout UI
private extension AgreementViewController {

    func createWebView() -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }

    func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        backButton.tintColor = .nftBlack
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView?.tintColor = .nftBlack
    }

    func setupUI() {
        view.backgroundColor = .nftWhite
        setupNavigationBar()
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
