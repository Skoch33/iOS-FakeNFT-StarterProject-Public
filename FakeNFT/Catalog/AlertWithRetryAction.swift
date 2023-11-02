import UIKit

final class AlertWithRetryAction {
    static let shared = AlertWithRetryAction()
    
    private var view: UIViewController?
    
    func show(view: UIViewController,
                      title: String,
                      action: @escaping () -> Void) {
        self.view = view
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: NSLocalizedString("Catalog.ErrorAlertButtonRetry", comment: ""),
                                        style: .default) { _ in
            action()
        }
        alert.addAction(alertAction)
        view.present(alert, animated: true)
    }
}
