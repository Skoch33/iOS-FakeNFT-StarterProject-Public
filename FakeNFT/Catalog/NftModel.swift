import Foundation

struct NftModel: Codable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let id: String
}
