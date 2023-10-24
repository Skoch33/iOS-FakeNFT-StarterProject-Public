//
//  ProfileService.swift
//  FakeNFT
//

import Foundation

protocol ProfileServiceProtocol: AnyObject {
    func getProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    private let networkClient: NetworkClient = DefaultNetworkClient()

    func getProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        let request = GetProfileRequest()
        networkClient.send(request: request, type: ProfileModel.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}