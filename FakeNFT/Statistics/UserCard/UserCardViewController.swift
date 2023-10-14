//
//  UserCardViewController.swift
//  FakeNFT
//

import UIKit

final class UserCardViewController: UIViewController {
    var users: User?
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    // MARK: - setupUI
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil,
                                                        action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        navigationController?.navigationBar.tintColor = .nftBlack
    }
    
    private func setupUI() {
        view.backgroundColor = .nftWhite
    }
}
