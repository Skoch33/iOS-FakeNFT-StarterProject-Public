import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    let webView = WKWebView()
    var urlString: String
    
    init(_ urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupWebView()
        showWebsiteAuthor()
    }
    
    private func setupNavigationController(){
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .nftBlack
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
    
    private func setupWebView() {
        view.backgroundColor = .nftWhite
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showWebsiteAuthor() {
        guard
            let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString)
        else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
}
