import Foundation

enum CatalogSortingModes: Int, CaseIterable {
    case byName, byCount
    
    var title: String {
        switch self {
        case .byName:
            return NSLocalizedString("Catalog.Sorting.ByName",
                                     comment: "")
        case .byCount:
            return NSLocalizedString("Catalog.Sorting.ByCount",
                                     comment: "")
        }
    }
}
