//
//  DeleteNftViewModel.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 13.10.2023.
//

import Foundation

protocol DeleteNftViewModelProtocol {
    func deleteButtonDidTap()
}

final class DeleteNftViewModel: DeleteNftViewModelProtocol {
    private weak var delegate: DeleteNftDelegate?
    private var nftId: String

    init(delegate: DeleteNftDelegate, nftId: String) {
        self.delegate = delegate
        self.nftId = nftId
    }

    func deleteButtonDidTap() {
        delegate?.deleteNftDidApprove(for: nftId)
    }
}
