//
//  BasketService.swift
//  FakeNFT
//

import Foundation

protocol BasketServiceProtocol: AnyObject {
    func getOrder(completion: @escaping (Result<OrderModel, Error>) -> Void)
    func updateOrder(updatedOrder: [String], completion: @escaping (Result<OrderModel, Error>) -> Void)
}

final class BasketService: BasketServiceProtocol {
    private let networkClient: NetworkClient = DefaultNetworkClient()

    func getOrder(completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let request = GetOrderRequest()
        networkClient.send(request: request, type: OrderModel.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func updateOrder(updatedOrder: [String], completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let putOrderRequest = PutOrderRequest(order: OrderModel(nfts: updatedOrder))
        networkClient.send(request: putOrderRequest, type: OrderModel.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
