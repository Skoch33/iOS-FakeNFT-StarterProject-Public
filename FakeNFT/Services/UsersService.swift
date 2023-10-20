//
//  UsersService.swift
//  FakeNFT
//

import Foundation

protocol UsersServiceProtocol: AnyObject {
    func getUsers(completion: @escaping (Result<[UserModel], Error>) -> Void)
}

final class UsersService: UsersServiceProtocol {
    private let networkClient: NetworkClient = DefaultNetworkClient()

    func getUsers(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        let request = GetUserRequest()
        networkClient.send(request: request, type: [UserModel].self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
