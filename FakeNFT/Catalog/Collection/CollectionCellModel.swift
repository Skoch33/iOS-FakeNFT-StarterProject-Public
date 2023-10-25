import Foundation

struct CollectionCellModel: Codable {
    let id: String
    let name: String?
    let image: String?
    var isLiked: Bool?
    var isInCart: Bool?
    let rating: Int?
    let price: Float?
}
