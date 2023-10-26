import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let userDefaults = UserDefaults.standard

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor.black
        window = UIWindow()

        let isFirstLaunch = userDefaults.bool(forKey: "isFirstLaunch")

        if isFirstLaunch {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = OnboardingViewController()
            userDefaults.set(true, forKey: "isFirstLaunch")
        }

        window?.makeKeyAndVisible()
        return true
    }
}
