//
//  DataProvider.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

import Foundation

protocol CartDataProviderProtocol {
    func getNumberOfNft() -> Int
    func getNftList() -> [String: CartNftInfo]
    func reloadData()
    func updateNftList(with nftList: [String])
    func removeNftFromCart(nftId: String)
}

extension CartDataProviderProtocol {
    var cartDidChangeNotification: Notification.Name { Notification.Name(rawValue: "cartNftListDidChange") }
}

final class CartDataProvider: CartDataProviderProtocol {
    private var nftList: [String: CartNftInfo] = [:]

    func getNumberOfNft() -> Int {
        nftList.count
    }

    func getNftList() -> [String: CartNftInfo] {
        nftList
    }

    func reloadData() {
        nftList.removeAll()
        NotificationCenter.default.post(
            name: cartDidChangeNotification,
            object: nil
        )
        NftListService.shared.get(onResponse: nftInCartDidReceive)
    }

    func updateNftList(with nftList: [String]) {
        NftListUpdateService.shared.put(
            newNftList: CartNftListUpdate(nfts: nftList),
            onResponse: nftInCartDidReceive
        )
    }

    func removeNftFromCart(nftId: String) {
        let updatedNftList: [String] = nftList.filter { $0.key != nftId }.map { $0.key }
        NftListUpdateService.shared.put(
            newNftList: CartNftListUpdate(nfts: updatedNftList),
            onResponse: nftInCartDidReceive
        )
    }

    private func nftInCartDidReceive(_ result: Result<CartNftList, Error>) {
        switch result {
        case .success(let nfts):
            nftList.removeAll()
            nfts.ids.forEach { id in
                let nftInfoService = NftInfoService()
                nftInfoService.get(for: id, onResponse: nftInfoDidReceive)
            }
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        }
    }

    private func nftInfoDidReceive(_ result: Result<CartNftInfo, Error>) {
        switch result {
        case .success(let nft):
            append(nft, for: nft.id)
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        }
    }

    private func append(_ nftInfo: CartNftInfo, for id: String) {
        nftList[id] = nftInfo
        NotificationCenter.default
            .post(
                name: cartDidChangeNotification,
                object: nil)
    }
}
