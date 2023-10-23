import Foundation

protocol CollectionViewModelProtocol {
    func bind(_ bindings: CollectionViewModelBindings)
    func load(nftIds: [String])
    func reversLike(nftId: String)
    func reversCart(nftId: String)
}

struct CollectionViewModelBindings {
    let isLoading: (Bool) -> Void
    let profile: (ProfileModel) -> Void
    let collectionCells: ([CollectionCellModel]) -> Void
    let isCollectionLoadError: (Bool) -> Void
    let isFailed: (Bool) -> Void
}

final class CollectionViewModel: CollectionViewModelProtocol {
    
    private let networkClient: NetworkClient
    
    var nfts: [NftModel] = []
    var order: OrderModel = OrderModel(nfts: [])
    
    @Observable
    var isLoading = false
    
    @Observable
    var collectionCells: [CollectionCellModel] = []
    
    @Observable
    var profile: ProfileModel = ProfileModel(name: "", website: "", likes: [])
    
    @Observable
    var isCollectionLoadError = false
    
    @Observable
    var isFailed = false
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func bind(_ bindings: CollectionViewModelBindings) {
        self.$isLoading.bind(action: bindings.isLoading)
        self.$profile.bind(action: bindings.profile)
        self.$isCollectionLoadError.bind(action: bindings.isCollectionLoadError)
        self.$isFailed.bind(action: bindings.isFailed)
        self.$collectionCells.bind(action: bindings.collectionCells)
    }
    
    func load(nftIds: [String]) {
        isLoading = true
        isCollectionLoadError = false
        loadProfile()
        loadOrder()
        loadCollection(nftIds: nftIds)
    }
    
    func makeCollectionCells(nftIds: [String]) {
        collectionCells = nftIds.map {
            let nftId = $0
            guard let index = nfts.firstIndex(where: { $0.id == nftId}) else {
                return CollectionCellModel(id: nftId,
                                    name: nil,
                                    image: nil,
                                    isLiked: nil,
                                    isInCart: nil,
                                    rating: nil,
                                    price: nil
                )
            }
            let isLiked = profile.likes.contains(where: { $0 == nftId })
            let isInCart = order.nfts.contains(where: { $0 == nftId })
            return CollectionCellModel(id: nftId,
                                name: nfts[index].name,
                                image: nfts[index].images[0],
                                isLiked: isLiked,
                                isInCart: isInCart,
                                rating: nfts[index].rating,
                                price: nfts[index].price
            )
        }
    }
    
    func loadProfile() {
        self.networkClient.send(request: GetProfileRequest(),
                                type: ProfileModel.self,
                                onResponse: {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.profile = model
                case .failure(_):
                    self.isCollectionLoadError = true
                }
            }
        })
    }
    
    func loadOrder() {
        self.networkClient.send(request: GetOrderRequest(),
                                type: OrderModel.self,
                                onResponse: {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.order = model
                case .failure(_):
                    self.isCollectionLoadError = true
                }
            }
        })
    }
    
    func loadCollection(nftIds: [String]) {
        let collectionGroup = DispatchGroup()
        
        nftIds.forEach { nftId in
            collectionGroup.enter()
            self.networkClient.send(request: GetNftRequest(nftId: nftId),
                                    type: NftModel.self,
                                    onResponse: {result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self.nfts.append(model)
                    case .failure(_):
                        self.isCollectionLoadError = true
                    }
                    collectionGroup.leave()
                }
            })
        }
        
        collectionGroup.notify(queue: .main) {
            self.makeCollectionCells(nftIds: nftIds)
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
        
        self.networkClient.send(request: PutProfileRequest(profile: profile),
                                type: ProfileModel.self,
                                onResponse: {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.profile = model
                    if let index = self.collectionCells.firstIndex(where: { $0.id == nftId}) {
                        self.collectionCells[index].isLiked =  self.profile.likes.contains(where: { $0 == nftId })
                    }
                case .failure(_):
                    self.isFailed = true
                }
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
        
        self.networkClient.send(request: PutOrderRequest(order: order),
                                type: OrderModel.self,
                                onResponse: {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.order = model
                    if let index = self.collectionCells.firstIndex(where: { $0.id == nftId}) {
                        self.collectionCells[index].isInCart =  self.order.nfts.contains(where: { $0 == nftId })
                    }
                case .failure(_):
                    self.isFailed = true
                }
            }
        })
    }
    
}

