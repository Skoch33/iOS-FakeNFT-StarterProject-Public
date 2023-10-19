//
//  NftListUpdateService.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

final class NftListUpdateService {

    static let shared = NftListUpdateService()

    private let networkClient = DefaultNetworkClient()
    private var task: NetworkTask?

    func put(newNftList: CartNftListUpdate, onResponse: @escaping (Result<CartNftList, Error>) -> Void) {
        task?.cancel()
        let request = NftListUpdateRequest(updatedNftList: newNftList)
        task = networkClient.send(request: request, type: OrderDto.self) { [weak self] result in
            self?.task = nil
            DispatchQueue.main.async {
                switch result {
                case .success(let dto):
                    let nftIds = CartNftList(dto: dto)
                    onResponse(.success(nftIds))
                case .failure(let error):
                    onResponse(.failure(error))
                }
            }
        }
    }
}
