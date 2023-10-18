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
    func deleteNftDidApprove(for id: String)
}

final class CartViewModel: CartViewModelProtocol {
    @Observable private var numberOfNft: Int
    @Observable private var priceTotal: Decimal
    @Observable private var nftList: [CartNftInfo]
    @Observable private var isEmptyCartPlaceholderDisplaying: Bool

    private var dataProvider: CartDataProviderProtocol
    private var settingsStorage: CartSettingsStorageProtocol
    private var sortingService: NftSortingServiceProtocol

    init(
        dataProvider: CartDataProviderProtocol,
        settingsStorage: CartSettingsStorageProtocol,
        sortingService: NftSortingServiceProtocol
    ) {
        self.dataProvider = dataProvider
        self.settingsStorage = settingsStorage
        self.sortingService = sortingService
        self.numberOfNft = 0
        self.priceTotal = 0
        self.nftList = []
        self.isEmptyCartPlaceholderDisplaying = true
    }

    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            forName: dataProvider.cartDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.updateNftList()
        }
        dataProvider.reloadData()
    }

    func bind(_ bindings: CartViewModelBindings) {
        self.$numberOfNft.bind(action: bindings.numberOfNft)
        self.$priceTotal.bind(action: bindings.priceTotal)
        self.$nftList.bind(action: bindings.nftList)
        self.$isEmptyCartPlaceholderDisplaying.bind(action: bindings.isEmptyCartPlaceholderDisplaying)
    }

    func sortOrderDidChange(to sortOder: CartSortOrder) {
        settingsStorage.cartSortOrder = sortOder
        // Для корзины предложил локальную сортировку без обращения к серверу (для оптимизации)
        // т.к. корзина содержит ограниченный набор заранее отобранных NFT
        nftList = sortingService.sorted(nftList, by: sortOder)
    }

    func deleteNftDidApprove(for id: String) {
        dataProvider.removeNftFromCart(nftId: id)
    }

    private func calcCartPriceTotal() -> Decimal {
        dataProvider.getNftList().reduce(Decimal(0), {$0 + $1.value.price})
    }

    private func updateNftList() {
        isEmptyCartPlaceholderDisplaying = dataProvider.getNumberOfNft() == 0
        numberOfNft = dataProvider.getNumberOfNft()
        priceTotal = calcCartPriceTotal()
        nftList = sortingService.sorted(dataProvider.getNftList().map({ $0.value }), by: settingsStorage.cartSortOrder)
    }
}
