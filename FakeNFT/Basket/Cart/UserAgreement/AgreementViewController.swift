//
//  AgreementViewController.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 23.10.2023.
//

import UIKit
import WebKit

final class AgreementViewController: UIViewController, WKNavigationDelegate {
    static let agreementURLString: String = "https://yandex.ru/legal/practicum_termsofuse/"

    private var viewModel: AgreementViewModelProtocol
    private var estimatedProgressObservation: NSKeyValueObservation?

    private lazy var webView = createWebView()
    private lazy var progressView = setupProgressView()

    init(viewModel: AgreementViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeProgressObservation()
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    @objc private func backButtonDidTap() {
        viewModel.backButtonDidTap()
    }

    private func subscribeProgressObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] webView, change in
                 guard let self else { return }
                 let newValue = change.newValue ?? webView.estimatedProgress
                 self.viewModel.didUpdateProgressValue(newValue)
             })
    }

    private func bindViewModel() {
        let bindings = AgreementViewModelBindings(
            isViewDismissing: { [ weak self ] in
                if $0 {
                    self?.navigationController?.popViewController(animated: true)
                }
            },
            isContentLoading: { [ weak self ] in
                if $0 {
                    guard let url = URL(string: Self.agreementURLString) else { return }
                    let request = URLRequest(url: url)
                    self?.webView.load(request)
                }
            },
            isContentProgressHidden: { [ weak self ] in
                self?.progressView.isHidden = $0
            },
            contentLoadingProgress: { [ weak self ] in
                self?.progressView.setProgress($0, animated: true)
            }
        )
        viewModel.bind(bindings)
    }
}

// MARK: Setup & Layout UI
private extension AgreementViewController {

    func createWebView() -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.backgroundColor = .nftWhite
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

    func setupProgressView() -> UIProgressView {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = .nftBlack
        return progress
    }

    func setupUI() {
        view.backgroundColor = .nftWhite
        setupNavigationBar()

        [webView, progressView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
