import Foundation

protocol CollectionViewModelProtocol {
    func bind(_ bindings: CollectionViewModelBindings)
    func load(nftIds: [String])
    func reversLike(nftId: String)
    func reversCart(nftId: String)
}

struct CollectionViewModelBindings {
    let isLoading: (Bool) -> Void
    let nfts: ([NftModel]) -> Void
    let profile: (ProfileModel) -> Void
    let order: (OrderModel) -> Void
    let isCollectionLoadError: (Bool) -> Void
    let isFailed: (Bool) -> Void
}

final class CollectionViewModel: CollectionViewModelProtocol {
    
    private let networkClient: NetworkClient
    
    @Observable
    var isLoading = false

    @Observable
    var nfts: [NftModel] = []
    
    @Observable
    var profile: ProfileModel = ProfileModel(name: "", website: "", likes: [])
    
    @Observable
    var order: OrderModel = OrderModel(nfts: [])
    
    @Observable
    var isCollectionLoadError = false
    
    @Observable
    var isFailed = false
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func bind(_ bindings: CollectionViewModelBindings) {
        self.$isLoading.bind(action: bindings.isLoading)
        self.$nfts.bind(action: bindings.nfts)
        self.$profile.bind(action: bindings.profile)
        self.$order.bind(action: bindings.order)
        self.$isCollectionLoadError.bind(action: bindings.isCollectionLoadError)
        self.$isFailed.bind(action: bindings.isFailed)
    }
    
    func load(nftIds: [String]) {
        self.isCollectionLoadError = false
        loadProfile()
        loadOrder()
        loadCollection(nftIds: nftIds)
    }
    
    func loadProfile() {
        isLoading = true
        self.networkClient.send(request: GetProfileRequest(),
                                type: ProfileModel.self,
                                onResponse: {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.profile = model
                    self.isLoading = false
                case .failure(_):
                    self.isCollectionLoadError = true
                    self.isLoading = false
                }
            }
        })
    }
    
    func loadOrder() {
        isLoading = true
        self.networkClient.send(request: GetOrderRequest(),
                                type: OrderModel.self,
                                onResponse: {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.order = model
                    self.isLoading = false
                case .failure(_):
                    self.isCollectionLoadError = true
                    self.isLoading = false
                }
            }
        })
    }
    
    func loadCollection(nftIds: [String]) {
        isLoading = true
        var nfts: [NftModel]
        nfts = nftIds.map {NftModel(name: "", images: [""], rating: 0, price: 0, id: $0)}
        let collectionGroup = DispatchGroup()
        
        nftIds.forEach { nftId in
            collectionGroup.enter()
            self.networkClient.send(request: GetNftRequest(nftId: nftId),
                                    type: NftModel.self,
                                    onResponse: {result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        if let index = nfts.firstIndex(where: { $0.id == model.id}) {
                            nfts[index] = model
                        }
                    case .failure(_):
                        self.isCollectionLoadError = true
                    }
                    collectionGroup.leave()
                }
            })
        }
        
        collectionGroup.notify(queue: .main) {
            self.nfts = nfts
            self.isLoading = false
        }
    }
    
    func reversLike(nftId: String) {
        isFailed = false
        if profile.likes.contains(where: {$0 == nftId}) {
            profile.likes.removeAll(where: {$0 == nftId})
        } else {
            profile.likes.append(nftId)
        }
        
        isLoading = true
        self.networkClient.send(request: PutProfileRequest(profile: profile),
                                type: ProfileModel.self,
                                onResponse: {result in
            DispatchQueue.main.async {
                if case .failure(_) = result {
                    self.isFailed = true
                }
                self.isLoading = false
            }
        })
    }
    
    func reversCart(nftId: String) {
        isFailed = false
        if order.nfts.contains(where: {$0 == nftId}) {
            order.nfts.removeAll(where: {$0 == nftId})
        } else {
            order.nfts.append(nftId)
        }
        
        isLoading = true
        self.networkClient.send(request: PutOrderRequest(order: order),
                                type: OrderModel.self,
                                onResponse: {result in
            DispatchQueue.main.async {
                if case .failure(_) = result {
                    self.isFailed = true
                }
                self.isLoading = false
            }
        })
    }
    
}

