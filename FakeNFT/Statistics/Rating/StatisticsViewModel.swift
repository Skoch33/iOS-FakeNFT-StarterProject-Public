//
//  StatisticsViewModel.swift
//  FakeNFT
//

import Foundation

enum SortType: String {
    case name
    case rating
    case none
}

protocol StatisticsViewModelProtocol: AnyObject {
    var dataChanged: (() -> Void)? { get set }
    var isDataLoading: ((Bool) -> Void)? { get set }
    var showError: ((Error) -> Void)? { get set }
    var users: [UserModel] { get set }
    func usersCount() -> Int
    func loadData()
    func sortUsersByName()
    func sortUsersByRating()
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    private let sortTypeKey = "sortTypeKey"

    var isDataLoading: ((Bool) -> Void)?

    var showError: ((Error) -> Void)?

    var dataChanged: (() -> Void)?

    var users: [UserModel] = [] {
        didSet {
            dataChanged?()
        }
    }

    private let usersService: UsersServiceProtocol

    init(usersService: UsersServiceProtocol = UsersService()) {
        self.usersService = usersService
    }

    func usersCount() -> Int {
        return users.count
    }

    func loadData() {
        isDataLoading?(true)

        usersService.getUsers { [weak self] users in
            self?.isDataLoading?(false)
            switch users {
            case .success(let user):
                self?.users = user
                self?.loadPreviousSortingState()
            case .failure(let error):
                self?.showError?(error)
                print(error.localizedDescription)
                return
            }
        }
    }

    func sortUsersByName() {
        users.sort { $0.name < $1.name }
        UserDefaults.standard.setValue(SortType.name.rawValue, forKey: sortTypeKey)
    }

    func sortUsersByRating() {
        users.sort {  Int($0.rating) ?? 0 < Int($1.rating) ?? 0 }
        UserDefaults.standard.setValue(SortType.rating.rawValue, forKey: sortTypeKey)
    }

    private func loadPreviousSortingState() {
        guard let sortTypeValue = UserDefaults.standard.value(forKey: sortTypeKey) as? String else { return }

        let sortType = SortType(rawValue: sortTypeValue) ?? .none

        switch sortType {
        case .name:
            sortUsersByName()
        case .rating:
            sortUsersByRating()
        case .none:
            break
        }
    }
}
