//
//  UsersCollectionViewModel.swift
//  FakeNFT
//

import Foundation

protocol UsersCollectionViewModelProtocol: AnyObject {
    var dataChanged: (() -> Void)? { get set }
    var isDataLoading: ((Bool) -> Void)? { get set }
    var showNetworkError: ((Error) -> Void)? { get set }
    var usersNFTCollectionByID: [String] { get set }
    var nfts: [NFTModel] { get set }
    func nftCount() -> Int
    func isLikedNFT(at index: Int) -> Bool
    func isOrderNFT(at index: Int) -> Bool
    func putOrderTapped(at indexPath: Int)
    func putLikeButtonTapped(at indexPath: Int)
    func viewDidLoad()
}

final class UsersCollectionViewModel: UsersCollectionViewModelProtocol {
    // MARK: - Properties
    var dataChanged: (() -> Void)?
    var isDataLoading: ((Bool) -> Void)?
    var showNetworkError: ((Error) -> Void)?

    var nfts: [NFTModel] = [] {
        didSet {
            dataChanged?()
        }
    }

    var usersNFTCollectionByID: [String] = []
    // MARK: - Private Properties
    private var myLikes: [String] = []
    private var myOrders: [String] = []

    private let nftService: NFTServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let basketService: BasketServiceProtocol
// MARK: - Init
    init(
        nftService: NFTServiceProtocol = NFTService(),
        profileService: ProfileServiceProtocol = ProfileService(),
        basketService: BasketServiceProtocol = BasketService()
    ) {
        self.nftService = nftService
        self.profileService = profileService
        self.basketService = basketService
    }
    // MARK: - Public Functions
    func nftCount() -> Int {
        return nfts.count
    }

    func isLikedNFT(at index: Int) -> Bool {
        guard index >= 0 && index < nfts.count else { return false }
        return myLikes.contains(nfts[index].id)
    }

    func isOrderNFT(at index: Int) -> Bool {
        guard index >= 0 && index < nfts.count else { return false }
        return myOrders.contains(nfts[index].id)
    }

    func viewDidLoad() {
        getNFTsFromUserCollection()
        getLikesFromOurProfile()
        getOrderFromMyProfile()
    }

    func putOrderTapped(at indexPath: Int) {
        let nftModel = nfts[indexPath]
        isDataLoading?(true)

        if myOrders.contains(nftModel.id) {
            guard let index = myOrders.firstIndex(of: nftModel.id) else { return }
            myOrders.remove(at: index)
        } else {
            myOrders.append(nftModel.id)
        }

        basketService.updateOrder(updatedOrder: myOrders ) {[weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let order):
                    self.myOrders = order.nfts
                    self.isDataLoading?(false)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    // MARK: - Private Functions
    func putLikeButtonTapped(at indexPath: Int) {
        let nftModel = nfts[indexPath]
        isDataLoading?(true)

        if myLikes.contains(nftModel.id) {
            guard let index = myLikes.firstIndex(of: nftModel.id) else { return }
            myLikes.remove(at: index)
        } else {
            myLikes.append(nftModel.id)
        }

        profileService.getProfile { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                let updatedProfile = ProfileModel(
                    name: profile.name,
                    avatar: profile.avatar,
                    description: profile.description,
                    website: profile.website,
                    nfts: profile.nfts,
                    likes: self.myLikes,
                    id: profile.id
                )
                self.profileService.updateProfile(profile: updatedProfile) { result in
                    switch result {
                    case .success(let likes):
                        self.myLikes = likes.likes
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                self.isDataLoading?(false)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


    private func getNFTsFromUserCollection() {
        let dispatchGroup = DispatchGroup()
        var loadedNFTs: [NFTModel] = []

        isDataLoading?(true)

        usersNFTCollectionByID.forEach { id in
            dispatchGroup.enter()
            nftService.getNFTs(id: id) { result in
                switch result {
                case .success(let nft):
                    loadedNFTs.append(nft)
                case .failure(let error):
                    self.showNetworkError?(error)
                    print(error.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            loadedNFTs.sort { $0.name < $1.name }
            self.nfts = loadedNFTs
            self.isDataLoading?(false)
        }
    }

    private func getLikesFromOurProfile() {
        profileService.getProfile { result in
            switch result {
            case .success(let myProfile):
                self.myLikes = myProfile.likes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func getOrderFromMyProfile() {
        basketService.getOrder { [weak self] result in
            switch result {
            case .success(let order):
                self?.myOrders = order.nfts
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
