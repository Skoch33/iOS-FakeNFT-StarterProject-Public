//
//  NftListService.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

import Foundation

final class NftListService {

    static let shared = NftListService()

    private let networkClient = DefaultNetworkClient()
    private var task: NetworkTask?

    func get(onResponse: @escaping (Result<CartNftList, Error>) -> Void) {
        task?.cancel()
        let request = NftListRequest()
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
