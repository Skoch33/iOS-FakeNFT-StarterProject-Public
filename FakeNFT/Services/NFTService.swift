//
//  NFTService.swift
//  FakeNFT
//

import Foundation

protocol NFTServiceProtocol: AnyObject {
    func getNFTs(id: String, completion: @escaping (NFT?) -> Void)
}

final class NFTService: NFTServiceProtocol {
    func getNFTs(id: String, completion: @escaping (NFT?) -> Void) {
        guard let url = URL(
            string: "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/nft/\(id)"
        ) else { return }

        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let nft = try decoder.decode(NFT.self, from: data)
                    completion(nft)
                } catch {
                    print("Error: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
