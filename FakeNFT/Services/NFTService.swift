import Foundation

final class NFTService {
    private let networkClient: NetworkClient
    private var currentTasks: [NetworkTask] = []
    static let shared = NFTService(networkClient: DefaultNetworkClient())
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchNFT(nftID: String,
                  completion: @escaping (Result<NFT, Error>) -> Void) {
        let request = FetchNFTNetworkRequest(nftID: nftID)
        networkClient.send(request: request, type: NFT.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func stopAllTasks() {
        currentTasks.forEach { $0.cancel() }
        currentTasks.removeAll()
    }
    
    func fetchAuthor(authorID: String,
                  completion: @escaping (Result<Author, Error>) -> Void) {
        let request = FetchAuthorNetworkRequest(authorID: authorID)
        networkClient.send(request: request, type: Author.self) { result in
            switch result {
            case .success(let author):
                completion(.success(author))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
