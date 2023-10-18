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
    private var task: NetworkTask?

    func getUsers(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        task?.cancel()
        let request = GetUserRequest()
        task = networkClient.send(request: request, type: [UserModel].self, onResponse: completion)
    }
}
