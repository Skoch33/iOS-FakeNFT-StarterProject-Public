//
//  UsersService.swift
//  FakeNFT
//

import Foundation

protocol UsersServiceProtocol: AnyObject {
    func getUsers(completion: @escaping ([User]?, Error?) -> Void)
}

final class UsersService: UsersServiceProtocol {
    func getUsers(completion: @escaping ([User]?, Error?) -> Void) {
        guard let url = URL(string: "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/users") else { return }
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode([User].self, from: data)
                    completion(users, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
