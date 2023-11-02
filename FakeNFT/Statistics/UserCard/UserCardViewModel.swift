//
//  UserCardViewModel.swift
//  FakeNFT
//

import Foundation

protocol UserCardViewModelProtocol {
    var user: UserModel? { get }
    var avatarUrl: URL? { get }
    var userName: String? { get }
    var userDescription: String? { get }
    var userWebsiteUrl: URL? { get }
    var nftsID: [String] { get }
    var onWebsiteButtonClick: ((URL) -> Void)? { get set }
    var onCollectionButtonClick: (([String]) -> Void)? { get set }
    func nftCount() -> Int
    func didTapOnWebsiteButton()
    func didTapOnCollectionButton()
}

final class UserCardViewModel: UserCardViewModelProtocol {
    var user: UserModel?

    var avatarUrl: URL? {
        if let avatarString = user?.avatar {
            return URL(string: avatarString)
        }
        return nil
    }

    var userName: String? {
        return user?.name
    }

    var userDescription: String? {
        return user?.description
    }

    var userWebsiteUrl: URL? {
        if let websiteString = user?.website {
            return URL(string: websiteString)
        }
        return nil
    }

    var nftsID: [String] {
        return user?.nfts ?? []
    }

    var onWebsiteButtonClick: ((URL) -> Void)?

    var onCollectionButtonClick: (([String]) -> Void)?

    func nftCount() -> Int {
        return user?.nfts.count ?? 0
    }

    func didTapOnWebsiteButton() {
        guard let userURL = userWebsiteUrl else { return }
        onWebsiteButtonClick?(userURL)
    }

    func didTapOnCollectionButton() {
        onCollectionButtonClick?(nftsID)
    }
}
