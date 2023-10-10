import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavBar()
        setupConstrains()
    }

    // MARK: - SetupUI
    
    private func setupBackground() {
        view.backgroundColor = .nftWhite
        view.tintColor = .nftBlack
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "editProfile"), style: .plain, target: self, action: #selector(presentEditViewController))
        navigationItem.rightBarButtonItem?.tintColor = .nftBlack
    }

    private lazy var profileAvatarImage: UIImageView = {
        var profileAvatarImage = UIImageView()
        profileAvatarImage.layer.cornerRadius = 35
        profileAvatarImage.clipsToBounds = true
        profileAvatarImage.image = UIImage(named: "avatar")
        profileAvatarImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileAvatarImage)
        return profileAvatarImage
    }()

    private lazy var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        profileNameLabel.font = .headline2
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.07
        profileNameLabel.attributedText = NSMutableAttributedString(string: "Joaquin Phoenix", attributes: [NSAttributedString.Key.kern: 1, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileNameLabel)
        return profileNameLabel
    }()

    private lazy var profileDescriptionLabel: UILabel = {
        let profileDescriptionLabel = UILabel()
        profileDescriptionLabel.font = .caption2
        profileDescriptionLabel.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        let attributedText = NSMutableAttributedString(string: profileDescriptionLabel.text ?? "")
        let paragrapthStyle = NSMutableParagraphStyle()
        paragrapthStyle.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: paragrapthStyle, range: NSRange(location: 0, length: attributedText.length))
        profileDescriptionLabel.attributedText = attributedText
        profileDescriptionLabel.numberOfLines = 0
        profileDescriptionLabel.lineBreakMode = .byWordWrapping
        profileDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescriptionLabel)
        return profileDescriptionLabel
    }()

    private lazy var profileSite: UILabel = {
        let profileSite = UILabel()
        profileSite.font = .caption1
        profileSite.text = "JoaquinPhoenix.com"
        profileSite.textColor = .nftBlueUniversal
        profileSite.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileSite)
        return profileSite
    }()

    private lazy var profileTableView: UITableView = {
        let profileTableView = UITableView()
        profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .none
        profileTableView.isScrollEnabled = false
        profileTableView.backgroundColor = .clear
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileTableView)
        return profileTableView
    }()

    private func setupConstrains() {
        NSLayoutConstraint.activate([
            profileAvatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileAvatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileAvatarImage.widthAnchor.constraint(equalToConstant: 70),
            profileAvatarImage.heightAnchor.constraint(equalToConstant: 70),
            profileNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImage.trailingAnchor, constant: 16),
            profileNameLabel.centerYAnchor.constraint(equalTo: profileAvatarImage.centerYAnchor),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileDescriptionLabel.topAnchor.constraint(equalTo: profileAvatarImage.bottomAnchor, constant: 20),
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileSite.topAnchor.constraint(equalTo: profileDescriptionLabel.bottomAnchor, constant: 12),
            profileSite.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileSite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileTableView.topAnchor.constraint(equalTo: profileSite.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }

    // MARK: - Actions
    
    @objc func presentEditViewController() {
        let editProfileViewController = EditProfileViewController()
        present(editProfileViewController, animated: true)
    }
}

    // MARK: - UITableViewDelegate&UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: UIImage(named: "forward"))
        cell.textLabel?.font = .bodyBold
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Мои NFT (112)"
        case 1:
            cell.textLabel?.text = "Избранные NFT (11)"
        case 2:
            cell.textLabel?.text = "О разработчике"
        default:
            cell.textLabel?.text =  ""
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
