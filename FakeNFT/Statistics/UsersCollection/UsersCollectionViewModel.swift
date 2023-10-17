//
//  UsersCollectionViewModel.swift
//  FakeNFT
//

import Foundation

protocol UsersCollectionViewModelProtocol: AnyObject {
    var dataChanged: (() -> Void)? { get set }
    var isDataLoading: ((Bool) -> Void)? { get set }
    var nftsID: [String] { get set }
    var nfts: [NFT] { get set }
    func nftCount() -> Int
    func loadData()
}

final class UsersCollectionViewModel: UsersCollectionViewModelProtocol {
    var isDataLoading: ((Bool) -> Void)?

    var dataChanged: (() -> Void)?

    var nftsID: [String] = []

    var nfts: [NFT] = [] {
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
        var loadedNFTs: [NFT] = []
        let dispatchQueue = DispatchQueue(label: "com.FakeNFT.NFTQueue")

        isDataLoading?(true)

        for id in nftsID {
            dispatchGroup.enter()
            dispatchQueue.async {
                self.nftService.getNFTs(id: id) { nft in
                    if let nft = nft {
                        dispatchQueue.sync {
                            loadedNFTs.append(nft)
                        }
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            loadedNFTs.sort { $0.name < $1.name }
            self.nfts = loadedNFTs
            self.isDataLoading?(false)
        }
    }
}
