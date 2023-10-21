import Foundation

private let baseURL = "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/"

struct GetNftRequest: NetworkRequest {
    let nft: String
    var endpoint: URL? {
        URL(string: "\(baseURL)nft/\(nft)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Encodable?
}

struct GetCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(baseURL)collections")
    }
    var httpMethod: HttpMethod = .get
    var dto: Encodable?
}

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(baseURL)profile/1")
    }
    var httpMethod: HttpMethod = .get
    var dto: Encodable?
}

struct GetOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(baseURL)orders/1")
    }
    var httpMethod: HttpMethod = .get
    var dto: Encodable?
}

