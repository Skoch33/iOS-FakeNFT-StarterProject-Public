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
    var users: [User] { get set }
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
    
    var users: [User] = [] {
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

        usersService.getUsers { [weak self] users, error in
            self?.isDataLoading?(false)
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.showError?(error)
                    self?.isDataLoading?(false)
                }
                print(error.localizedDescription)
                return
            }
            
            if let users = users {
                DispatchQueue.main.async { [weak self] in
                    self?.users = users
                    self?.loadPreviousSortingState()
                    self?.isDataLoading?(false)
                }
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
