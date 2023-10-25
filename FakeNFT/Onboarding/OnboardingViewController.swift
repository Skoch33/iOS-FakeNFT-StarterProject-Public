//
//  OnboardingViewController.swift
//  FakeNFT
//

import UIKit

final class OnboardingViewController: UIViewController {
    // MARK: - Private Properties
    private let firstImage = UIImage(named: "firstOnboardingImage")
    private let secondImage = UIImage(named: "secondOnboardingImage")
    private let thirdImage = UIImage(named: "thirdOnboardingImage")
    private let closeImage = UIImage(named: "closeButtonIcon")
    private let userDefaults = UserDefaults.standard
    // MARK: - Subviews
    private lazy var pageViewController: UIPageViewController = {
        let pageController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageController.dataSource = self
        pageController.delegate = self
        return pageController
    }()

    private lazy var pageControl: CustomPageControl = {
        let pageControl = CustomPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        return pageControl
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(closeImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(goToMainScreen), for: .touchUpInside)
        return button
    }()

    private lazy var insideButton: UIButton = {
        let button = UIButton()
        button.setTitle("Что внутри?", for: .normal)
        button.titleLabel?.font = .NftBodyFonts.bold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .nftBlackUniversal
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(goToMainScreen), for: .touchUpInside)
        return button
    }()

    private lazy var pages: [UIViewController] = {
        let firstOnboardingView = OnboardingView(
            frame: view.bounds,
            image: firstImage ?? UIImage(),
            headerText: "Исследуйте",
            descriptionText: "Присоединяйтесь и откройте новый мир уникальных NFT для коллекционеров"
        )
        let firstViewController = UIViewController()
        firstViewController.view = firstOnboardingView

        let secondOnboardingView = OnboardingView(
            frame: view.bounds,
            image: secondImage ?? UIImage(),
            headerText: "Коллекционируйте",
            descriptionText: "Пополняйте свою коллекцию эксклюзивными картинками, созданными нейросетью!"
        )
        let secondViewController = UIViewController()
        secondViewController.view = secondOnboardingView

        let thirdOnboardingView = OnboardingView(
            frame: view.bounds,
            image: thirdImage ?? UIImage(),
            headerText: "Состязайтесь",
            descriptionText: "Смотрите статистику других и покажите всем, что у вас самая ценная коллекция"
        )
        let thirdViewController = UIViewController()
        thirdViewController.view = thirdOnboardingView

        return [firstViewController, secondViewController, thirdViewController]
    }()
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupSubviews()
    }
    // MARK: - Action
    @objc
    private func goToMainScreen() {
        let tabBarViewController = TabBarController()
        tabBarViewController.modalPresentationStyle = .fullScreen
        show(tabBarViewController, sender: nil)
        completeOnboarding()
    }
    // MARK: - Setup Subviews
    private func setupSubviews() {
        [pageViewController.view, pageControl, closeButton, insideButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        insideButton.isHidden = true
        addChild(pageViewController)

        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            insideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            insideButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            insideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -66),
            insideButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupPageViewController() {
        if let first = pages.first {
            pageViewController.setViewControllers([first], direction: .forward, animated: true)
        }
    }

    func completeOnboarding() {
        userDefaults.set(true, forKey: "isFirstLaunch")
    }
}
// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }

        return pages[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }

        return pages[nextIndex]
    }
}
// MARK: - UIPageViewControllerDaelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex

            UIView.animate(withDuration: 0.45, animations: {
                self.closeButton.alpha = (currentIndex == self.pages.count - 1) ? 0 : 1
                self.insideButton.alpha = (currentIndex != self.pages.count - 1) ? 0 : 1
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.closeButton.isHidden = self.closeButton.alpha == 0
                self.insideButton.isHidden = self.insideButton.alpha == 0
            })
        }
    }
}
