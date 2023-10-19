//
//  CartPaymentInfoDto.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 16.10.2023.
//

import Foundation

struct CartPaymentInfoDto: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}
