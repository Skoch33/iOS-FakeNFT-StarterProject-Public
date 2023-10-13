//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 12.10.2023.
//

import Foundation

protocol CartViewModelProtocol {
    func viewDidLoad()
    func bind(_ bindings: CartViewModelBindings)
    func sortOrderDidChange(to sortBy: CartSortOrder)
}

struct CartViewModelBindings {
    let numberOfNft: (Int) -> Void
    let priceTotal: (Decimal) -> Void
    let nftList: ([CartNftInfo]) -> Void
    let isEmptyCartPlaceholderDisplaying: (Bool) -> Void
}

final class CartViewModel: CartViewModelProtocol {
    @Observable private var numberOfNft: Int
    @Observable private var priceTotal: Decimal
    @Observable private var nftList: [CartNftInfo]
    @Observable private var isEmptyCartPlaceholderDisplaying: Bool

    private var dataProvider: CartDataProviderProtocol

    init(dataProvider: CartDataProviderProtocol) {
        self.dataProvider = dataProvider
        self.numberOfNft = 0
        self.priceTotal = Decimal(0)
        self.nftList = []
        self.isEmptyCartPlaceholderDisplaying = true
    }

    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            forName: dataProvider.cartDidChangeNotification,
            object: nil,
            queue: .main) {[weak self] _ in
                guard let self else { return }
                self.updateNftList()
            }
        dataProvider.getAllNftInCart()
    }

    func bind(_ bindings: CartViewModelBindings) {
        self.$numberOfNft.bind(action: bindings.numberOfNft)
        self.$priceTotal.bind(action: bindings.priceTotal)
        self.$nftList.bind(action: bindings.nftList)
        self.$isEmptyCartPlaceholderDisplaying.bind(action: bindings.isEmptyCartPlaceholderDisplaying)
    }

    func sortOrderDidChange(to sortBy: CartSortOrder) {
        // TODO: реализовать сортировку nftList
        print("change sort order to: \(sortBy)")
    }

    private func calcCartPriceTotal() -> Decimal {
        dataProvider.nftList.reduce(Decimal(0), {$0 + $1.value.price})
    }

    private func updateNftList() {
        isEmptyCartPlaceholderDisplaying = dataProvider.nftList.isEmpty
        numberOfNft = dataProvider.numberOfNft
        priceTotal = calcCartPriceTotal()
        nftList = dataProvider.nftList.map { $0.value }
    }
}
