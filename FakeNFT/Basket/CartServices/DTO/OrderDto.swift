//
//  OderDto.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 11.10.2023.
//

struct OrderDto: Decodable {
    let nfts: [String]
    let id: String
}
