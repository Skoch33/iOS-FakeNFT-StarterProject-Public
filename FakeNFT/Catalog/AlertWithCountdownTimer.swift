import UIKit

final class AlertWithCountdownTimer {
    static let shared = AlertWithCountdownTimer()
    
    private var timer = Timer()
    private var timerCount: Int = 0
    private var view: UIViewController?
    private var action: () -> Void = { return }
    
    private func message() -> String {
        NSLocalizedString("Catalog.ErrorAlertMessage", comment: "") + String.localizedStringWithFormat(
            NSLocalizedString("numberOfSeconds", comment: ""), timerCount)
    }
    
    func show(view: UIViewController, 
              title: String,
              timerCount: Int,
              action: @escaping () -> Void) {
        self.view = view
        self.timerCount = timerCount
        self.action = action
        let alert = UIAlertController(
            title: title,
            message: self.message(),
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: NSLocalizedString("Catalog.ErrorAlertButtonCancel", comment: ""),
                                   style: .cancel,
                                   handler: nil)
        alert.addAction(action)
        view.present(alert, animated: true) { () -> Void in
            self.timer = Timer.scheduledTimer(timeInterval: 1, 
                                              target: self,
                                              selector: #selector(self.countDownTimer),
                                              userInfo: nil,
                                              repeats: true)
        }
    }
    
    @objc private func countDownTimer() {
        timerCount -= 1
        guard let alertController = view?.presentedViewController as? UIAlertController else { return }
        alertController.message = self.message()
        if self.timerCount == 0 {
            self.timer.invalidate()
            alertController.dismiss(animated: true, completion: nil)
            self.action()
        }
    }
}
