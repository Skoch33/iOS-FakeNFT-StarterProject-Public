import Foundation

final class CatalogViewModel {

    private var sortMode = CatalogSortingModes.byCount
    private let catalogSortingModeKey = "CatalogSortingMode"

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

    func load() {
        print(">>> \(sortMode)")
    }

    func sort(_ mode: CatalogSortingModes) {
        sortMode = mode
        saveSortMode()
    }

}
