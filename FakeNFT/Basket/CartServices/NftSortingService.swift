//
//  NftSortingService.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 12.10.2023.
//

import Foundation

protocol NftSortingServiceProtocol {
    func sorted(_ unsorted: [CartNftInfo], by sortOrder: CartSortOrder) -> [CartNftInfo]
}

final class DefaultNftSortingService: NftSortingServiceProtocol {
    typealias NftSortingPredicate = (CartNftInfo, CartNftInfo) -> Bool

    private let sortPredicates: [CartSortOrder: NftSortingPredicate] = [
        .byName: { $0.name < $1.name },
        // обратная сортировка по рейтингу и цене сделана осознанно: лучшие/дорогие - вверху списка (в ТЗ не оговорено)
        .byPrice: { $0.price > $1.price },
        .byRating: { $0.rating > $1.rating }
    ]

    func sorted(_ unsorted: [CartNftInfo], by sortOrder: CartSortOrder) -> [CartNftInfo] {
        guard let sortPredicate = sortPredicates[sortOrder] else { return unsorted }
        return unsorted.sorted(by: sortPredicate)
    }
}
