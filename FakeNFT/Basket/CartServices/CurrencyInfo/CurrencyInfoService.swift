//
//  CurrencyInfoService.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

final class CurrencyInfoService {

    private let networkClient = DefaultNetworkClient()
    private var task: NetworkTask?
    private var currencyId: String?

    func get(for id: String, onResponse: @escaping (Result<CartCurrency, Error>) -> Void) {
        if id == currencyId && task != nil { return }

        let request = CartCurrencyRequest(id: id)
        task = networkClient.send(request: request, type: CurrencyDto.self) { [weak self] result in
            self?.task = nil
            self?.currencyId = nil
            DispatchQueue.main.async {
                switch result {
                case .success(let dto):
                    let currencyInfo = CartCurrency(dto: dto)
                    onResponse(.success(currencyInfo))
                case .failure(let error):
                    onResponse(.failure(error))
                }
            }
        }
    }
}
