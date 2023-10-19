//
//  CartCellViewModel.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 12.10.2023.
//

import Foundation

protocol CartCellViewModelProtocol {
    func cellReused(for nft: CartNftInfo)
    func bind(_ bindings: CartCellViewModelBindings)
    func deleteButtonDidTap(image: Any?)
}

protocol CartCellDelegate: AnyObject {
    func deleteButtonDidTap(for nftId: String, with image: Any?, imageURL: URL?)
}

final class CartCellViewModel: CartCellViewModelProtocol {
    @Observable private var rating: Int = 0
    @Observable private var price: Decimal = 0
    @Observable private var name: String = ""
    @Observable private var imageURL: URL?

    private weak var delegate: CartCellDelegate?
    private var nftId: String

    init(delegate: CartCellDelegate, nftId: String) {
        self.delegate = delegate
        self.nftId = nftId
    }

    func cellReused(for nft: CartNftInfo) {
        rating = nft.rating
        price = nft.price
        name = nft.name
        imageURL = URL(string: nft.imageURLString ?? "")
    }

    func bind(_ bindings: CartCellViewModelBindings) {
        self.$rating.bind(action: bindings.rating)
        self.$price.bind(action: bindings.price)
        self.$name.bind(action: bindings.name)
        self.$imageURL.bind(action: bindings.imageURL)
    }

    func deleteButtonDidTap(image: Any?) {
        delegate?.deleteButtonDidTap(for: nftId, with: image, imageURL: imageURL)
    }
}
