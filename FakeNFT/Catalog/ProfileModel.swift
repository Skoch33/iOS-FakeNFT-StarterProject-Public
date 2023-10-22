import Foundation

struct ProfileModel: Codable {
    let name: String
    let website: String
    var likes: [String]
}
