import Foundation

protocol CatalogViewModelProtocol {
    func bind(_ bindings: CatalogViewModelBindings)
    func loadCollection()
    func sort(_ mode: CatalogSortingModes)
}

struct CatalogViewModelBindings {
    let isLoading: (Bool) -> Void
    let collections: ([CollectionModel]) -> Void
    let errorString: (String) -> Void
}

final class CatalogViewModel: CatalogViewModelProtocol {
    
    private var sortMode = CatalogSortingModes.byCount
    private let catalogSortingModeKey = "CatalogSortingMode"
    private let networkClient: NetworkClient
    
    @Observable
    var collections: [CollectionModel] = []
    
    @Observable
    var isLoading = false
    
    @Observable
    var errorString: String = ""
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        self.loadSortMode()
    }
    
    func bind(_ bindings: CatalogViewModelBindings) {
        self.$isLoading.bind(action: bindings.isLoading)
        self.$collections.bind(action: bindings.collections)
        self.$errorString.bind(action: bindings.errorString)
    }
    
    private func loadSortMode() {
        if UserDefaults.standard.object(forKey: catalogSortingModeKey) == nil {
            sortMode = .byCount
            UserDefaults.standard.set(sortMode.rawValue, forKey: catalogSortingModeKey)
        }
        sortMode = CatalogSortingModes(rawValue: UserDefaults.standard.integer(forKey: catalogSortingModeKey)) ?? .byCount
    }
    
    private func saveSortMode() {
        UserDefaults.standard.set(sortMode.rawValue, forKey: catalogSortingModeKey)
    }
    
    func sort(_ mode: CatalogSortingModes) {
        sortMode = mode
        saveSortMode()
        collections = collections.collectionSort(sortMode)
    }
    
    func loadCollection() {
        isLoading = true
        DispatchQueue.global().async {
            self.networkClient.send(request: GetCollectionsRequest(),
                                    type: [CollectionModel].self,
                                    onResponse: {result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self.collections = model.collectionSort(self.sortMode)
                        self.isLoading = false
                    case .failure(let error):
                        self.errorString = error.localizedDescription
                        self.isLoading = false
                    }
                }
            })
        }
    }
    
}

extension Array where Element == CollectionModel {
    
    func collectionSort(_ mode: CatalogSortingModes) -> [Element] {
        switch mode {
        case .byName:
            return self.sorted(by: {$0.name < $1.name})
        case .byCount:
            return self.sorted(by: {$0.nfts.count > $1.nfts.count})
        }
    }
    
}
