//
//  CartPaymentService.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

final class CartPaymentService {

    static let shared = CartPaymentService()
    private let networkClient = DefaultNetworkClient()
    private var task: NetworkTask?

    func pay(withCurrency id: String, onResponse: @escaping (Result<Bool, Error>) -> Void) {
        if task != nil { return }

        let request = CartPaymentRequest(forCurrency: id)
        task = networkClient.send(request: request, type: CartPaymentInfoDto.self) { [weak self] result in
            self?.task = nil
            DispatchQueue.main.async {
                switch result {
                case .success(let dto):
                    let isPaymentSuccessful = dto.success
                    onResponse(.success(isPaymentSuccessful))
                case .failure(let error):
                    onResponse(.failure(error))
                }
            }
        }
    }
}
