//
//  NFTService.swift
//  FakeNFT
//

import Foundation

protocol NFTServiceProtocol: AnyObject {
    func getNFTs(id: String, completion: @escaping (Result<NFTModel, Error>) -> Void)
}

final class NFTService: NFTServiceProtocol {
    private let networkClient: NetworkClient = DefaultNetworkClient()
    
    func getNFTs(id: String, completion: @escaping (Result<NFTModel, Error>) -> Void) {
        let request = GetNFTRequest(id: id)
        networkClient.send(request: request, type: NFTModel.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
