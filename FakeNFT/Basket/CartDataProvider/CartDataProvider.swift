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
    var cartDidChangeNotificationFailed: Notification.Name { Notification.Name(rawValue: "cartNftListDidChangeFailed") }
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
                NftInfoService.shared.get(for: id, onResponse: self.nftInfoDidReceive)
            }
        case .failure:
            NotificationCenter.default.post(
                name: cartDidChangeNotificationFailed,
                object: nil
            )
        }
    }

    private func nftInfoDidReceive(_ result: Result<CartNftInfo, Error>) {
        switch result {
        case .success(let nft):
            append(nft, for: nft.id)
        case .failure:
            NotificationCenter.default.post(
                name: cartDidChangeNotificationFailed,
                object: nil
            )
        }
    }

    private func append(_ nftInfo: CartNftInfo, for id: String) {
        nftList[id] = nftInfo
        NotificationCenter.default.post(
            name: cartDidChangeNotification,
            object: nil
        )
    }
}
