//
//  UsersCollectionViewModel.swift
//  FakeNFT
//

import Foundation

protocol UsersCollectionViewModelProtocol: AnyObject {
    var dataChanged: (() -> Void)? { get set }
    var isDataLoading: ((Bool) -> Void)? { get set }
    var nftsID: [String] { get set }
    var nfts: [NFTModel] { get set }
    func nftCount() -> Int
    func loadData()
}

final class UsersCollectionViewModel: UsersCollectionViewModelProtocol {
    var isDataLoading: ((Bool) -> Void)?

    var dataChanged: (() -> Void)?

    var nftsID: [String] = []

    var nfts: [NFTModel] = [] {
        didSet {
            dataChanged?()
        }
    }

    func nftCount() -> Int {
        return nfts.count
    }

    private let nftService: NFTServiceProtocol

    init(nftService: NFTServiceProtocol = NFTService()) {
        self.nftService = nftService
    }

    func loadData() {
        let dispatchGroup = DispatchGroup()
        var loadedNFTs: [NFTModel] = []

        isDataLoading?(true)

        for id in nftsID {
            dispatchGroup.enter()
            nftService.getNFTs(id: id) { result in
                switch result {
                case .success(let nft):
                    loadedNFTs.append(nft)
                case .failure(let error):
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
}
