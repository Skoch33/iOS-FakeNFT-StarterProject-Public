import Foundation

protocol CollectionViewModelProtocol {
    func bind(_ bindings: CollectionViewModelBindings)
    func loadCollection(nftIds: [String])
}

struct CollectionViewModelBindings {
    let isLoading: (Bool) -> Void
    let nfts: ([NftModel]) -> Void
}

final class CollectionViewModel: CollectionViewModelProtocol {
    
    private let networkClient: NetworkClient
    
    @Observable
    var isLoading = false

    @Observable
    var nfts: [NftModel] = []
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func bind(_ bindings: CollectionViewModelBindings) {
        self.$isLoading.bind(action: bindings.isLoading)
        self.$nfts.bind(action: bindings.nfts)
    }
    
    func loadCollection(nftIds: [String]) {
        isLoading = true
        var nfts: [NftModel]
        nfts = nftIds.map {NftModel(name: "", images: [""], rating: 0, price: 0, id: $0)}
        let collectionGroup = DispatchGroup()
        
        nftIds.forEach { nftId in
            collectionGroup.enter()
            self.networkClient.send(request: GetNftRequest(nft: nftId),
                                    type: NftModel.self,
                                    onResponse: {result in
                DispatchQueue.main.async {
                    if case .success(let model) = result {
                        if let index = nfts.firstIndex(where: { $0.id == model.id}) {
                            nfts[index] = model
                        }
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
    
}

