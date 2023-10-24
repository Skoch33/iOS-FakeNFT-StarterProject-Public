//
//  NftInfoService.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

import Foundation

final class NftInfoService {

    static let shared = NftInfoService()
    private let networkClient = DefaultNetworkClient()
    private var task: NetworkTask?
    private var currentId: String?

    func get(for id: String, onResponse: @escaping (Result<CartNftInfo, Error>) -> Void) {
        if id == currentId && task != nil { return }

        let request = NFTInfoRequest(id: id)
        task = networkClient.send(request: request, type: NftInfoDto.self) { [weak self] result in
            self?.task = nil
            self?.currentId = nil
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let nftInfo = CartNftInfo(dto: data)
                    onResponse(.success(nftInfo))
                case .failure(let error):
                    onResponse(.failure(error))
                }
            }
        }
    }
}
