import Foundation
import ProgressHUD

final class CatalogViewModel {

    private var sortMode = CatalogSortingModes.byCount
    private let catalogSortingModeKey = "CatalogSortingMode"
    private let networkClient: NetworkClient = DefaultNetworkClient()

    @Observable
    var collections: [CollectionModel] = []

    @Observable
    var errorString: String = ""

    init() {
        self.loadSortMode()
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

    struct CollectionRequest: NetworkRequest {
        var endpoint: URL? {
            URL(string: "https://651ff0d9906e276284c3c20a.mockapi.io//api/v1/collections")
        }
        var httpMethod: HttpMethod = .get
        var dto: Encodable?
    }

    func loadCollection() {
        ProgressHUD.show()
        DispatchQueue.global().async {
            self.networkClient.send(request: CollectionRequest(),
                                    type: [CollectionModel].self,
                                    onResponse: {result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self.collections = model.collectionSort(self.sortMode)
                        ProgressHUD.dismiss()
                    case .failure(let error):
                        self.errorString = error.localizedDescription
                        ProgressHUD.dismiss()
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
