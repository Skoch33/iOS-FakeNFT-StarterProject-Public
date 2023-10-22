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
    var myLikes: [String] { get set }
    func nftCount() -> Int
    func isLikedNFT(at index: Int) -> Bool
    func viewDidLoad()
}

final class UsersCollectionViewModel: UsersCollectionViewModelProtocol {
    var dataChanged: (() -> Void)?
    var isDataLoading: ((Bool) -> Void)?
    var showNetworkError: ((Error) -> Void)?

    var nfts: [NFTModel] = [] {
        didSet {
            dataChanged?()
        }
    }

    var usersNFTCollectionByID: [String] = []
    var myLikes: [String] = []

    private let nftService: NFTServiceProtocol
    private let profileService: ProfileServiceProtocol

    init(
        nftService: NFTServiceProtocol = NFTService(),
        profileService: ProfileServiceProtocol = ProfileService()
    ) {
        self.nftService = nftService
        self.profileService = profileService
    }

    func nftCount() -> Int {
        return nfts.count
    }

    func isLikedNFT(at index: Int) -> Bool {
        guard index >= 0 && index < nfts.count else { return false }
        return myLikes.contains(nfts[index].id)
    }

    // MARK: - Load Data
    func viewDidLoad() {
        getNFTsFromUserCollection()
        getLikesFromOurProfile()
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
}
