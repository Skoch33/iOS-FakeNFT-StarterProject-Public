//
//  UserCardViewModel.swift
//  FakeNFT
//

import Foundation

protocol UserCardViewModelProtocol {
    var user: User? { get }
    var avatarUrl: URL? { get }
    var userName: String? { get }
    var userDescription: String? { get }
    var userWebsiteUrl: URL? { get }
    var nftCount: Int { get }
    var nftsID: [String] { get }
    var onWebsiteButtonClick: (() -> ())? { get set }
    var onCollectionButtonClick: (() -> ())? { get set }
}

final class UserCardViewModel: UserCardViewModelProtocol {

    var user: User?

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

    var nftCount: Int {
        return user?.nfts.count ?? 0
    }
    
    var nftsID: [String] {
        return user?.nfts ?? []
    }

    var onWebsiteButtonClick: (() -> ())?

    var onCollectionButtonClick: (() -> ())?
}
