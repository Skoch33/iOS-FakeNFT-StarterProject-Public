//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Semen Kocherga on 10.10.2023.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupConstrains()
    }
    
    // MARK: - SetupUI
    
    private func setupBackground() {
        view.backgroundColor = .nftWhite
        view.tintColor = .nftBlack
    }
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        return closeButton
    }()
    
    private lazy var editAvatarButton: UIButton = {
        let editAvatarButton = UIButton()
        editAvatarButton.setImage(UIImage(named: "profileMockImage"), for: .normal)
        editAvatarButton.backgroundColor = .nftBackgroundUniversal
        editAvatarButton.layer.cornerRadius = 35
        editAvatarButton.setTitle(NSLocalizedString("EditProfileViewController.changePhoto", comment: ""), for: .normal)
        editAvatarButton.titleLabel?.font = .caption3
        editAvatarButton.setTitleColor(.nftWhite, for: .normal)
        editAvatarButton.titleLabel?.textAlignment = .center
        editAvatarButton.titleLabel?.numberOfLines = 0
        editAvatarButton.clipsToBounds = true
        editAvatarButton.layer.zPosition = 2
        editAvatarButton.addTarget(self, action: #selector(editAvatarButtonTapped), for: .touchUpInside)
        editAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editAvatarButton)
        return editAvatarButton
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = (NSLocalizedString("EditProfileViewController.name", comment: ""))
        nameLabel.font = .headline2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        return nameLabel
    }()
    
    private lazy var nameUnderView: UIView = {
        let nameUnderView = UIView()
        nameUnderView.layer.cornerRadius = 12
        nameUnderView.backgroundColor = .nftLightgrey
        nameUnderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameUnderView)
        return nameUnderView
    }()
    
    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.font = .bodyRegular
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameUnderView.addSubview(nameTextField)
        return nameTextField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = (NSLocalizedString("EditProfileViewController.description", comment: ""))
        descriptionLabel.font = .headline2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        return descriptionLabel
    }()
    
    private lazy var descriptionUnderView: UIView = {
        let descriptionUnderView = UIView()
        descriptionUnderView.layer.cornerRadius = 12
        descriptionUnderView.backgroundColor = .nftLightgrey
        descriptionUnderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionUnderView)
        return descriptionUnderView
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let descriptionTextField = UITextField()
        descriptionTextField.font = .bodyRegular
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionUnderView.addSubview(descriptionTextField)
        return descriptionTextField
    }()
    
    private lazy var siteLabel: UILabel = {
        let siteLabel = UILabel()
        siteLabel.text = (NSLocalizedString("EditProfileViewController.site", comment: ""))
        siteLabel.font = .headline2
        siteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(siteLabel)
        return siteLabel
    }()
    
    private lazy var siteUnderView: UIView = {
        let siteUnderView = UIView()
        siteUnderView.layer.cornerRadius = 12
        siteUnderView.backgroundColor = .nftLightgrey
        siteUnderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(siteUnderView)
        return siteUnderView
    }()
    
    private lazy var siteTextField: UITextField = {
        let siteTextField = UITextField()
        siteTextField.font = .bodyRegular
        siteTextField.translatesAutoresizingMaskIntoConstraints = false
        siteUnderView.addSubview(siteTextField)
        return siteTextField
    }()
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            editAvatarButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            editAvatarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editAvatarButton.heightAnchor.constraint(equalToConstant: 70),
            editAvatarButton.widthAnchor.constraint(equalToConstant: 70),
            nameLabel.topAnchor.constraint(equalTo: editAvatarButton.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameUnderView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameUnderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameUnderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameUnderView.heightAnchor.constraint(equalToConstant: 44),
            nameTextField.leadingAnchor.constraint(equalTo: nameUnderView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: nameUnderView.trailingAnchor, constant: -16),
            nameTextField.centerYAnchor.constraint(equalTo: nameUnderView.centerYAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameUnderView.bottomAnchor, constant: 22),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionUnderView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionUnderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionUnderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionUnderView.heightAnchor.constraint(equalToConstant: 135),
            descriptionTextField.leadingAnchor.constraint(equalTo: descriptionUnderView.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: descriptionUnderView.trailingAnchor, constant: -16),
            descriptionTextField.topAnchor.constraint(equalTo: descriptionUnderView.topAnchor, constant: -11),
            descriptionTextField.bottomAnchor.constraint(equalTo: descriptionUnderView.bottomAnchor, constant: 11),
            siteLabel.topAnchor.constraint(equalTo: descriptionUnderView.bottomAnchor, constant: 22),
            siteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            siteUnderView.topAnchor.constraint(equalTo: siteLabel.bottomAnchor, constant: 8),
            siteUnderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            siteUnderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            siteUnderView.heightAnchor.constraint(equalToConstant: 44),
            siteTextField.leadingAnchor.constraint(equalTo: siteUnderView.leadingAnchor, constant: 16),
            siteTextField.trailingAnchor.constraint(equalTo: siteUnderView.trailingAnchor, constant: -16),
            siteTextField.centerYAnchor.constraint(equalTo: siteUnderView.centerYAnchor)
        ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func editAvatarButtonTapped() {
    }
}
