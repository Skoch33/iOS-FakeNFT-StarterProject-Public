//
//  DataProvider.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

import Foundation

protocol CartDataProviderProtocol {
    var numberOfNft: Int { get }
    var nftList: [String: CartNftInfo] { get }
    var cartDidChangeNotification: Notification.Name { get }
    func getAllNftInCart()
}

extension CartDataProviderProtocol {
    var cartDidChangeNotification: Notification.Name { Notification.Name(rawValue: "cartNftListDidChange") }
}

final class CartDataProvider: CartDataProviderProtocol {

    var numberOfNft: Int { nftList.count }
    private(set) var nftList: [String: CartNftInfo] = [:]

    func getAllNftInCart() {
        nftList.removeAll()
        NotificationCenter.default.post(
            name: self.cartDidChangeNotification,
            object: nil
        )
        NftListService.shared.get(onResponse: nftInCartDidReceive)
    }

    private func nftInCartDidReceive(_ result: Result<CartNftList, Error>) {
        switch result {
        case .success(let nfts):
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
                name: self.cartDidChangeNotification,
                object: nil)
    }
}
