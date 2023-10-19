//
//  CurrencyListService.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

final class CurrencyListService {

    static let shared = CurrencyListService()

    private let networkClient = DefaultNetworkClient()
    private var task: NetworkTask?

    func get(onResponse: @escaping (Result<CartCurrencyList, Error>) -> Void) {
        task?.cancel()
        let request = CartCurrencyListRequest()
        task = networkClient.send(request: request, type: [CurrencyDto].self) { [weak self] result in
            self?.task = nil
            DispatchQueue.main.async {
                switch result {
                case .success(let dto):
                    let currencyList = CartCurrencyList(dto: dto)
                    onResponse(.success(currencyList))
                case .failure(let error):
                    onResponse(.failure(error))
                }
            }
        }
    }
}
