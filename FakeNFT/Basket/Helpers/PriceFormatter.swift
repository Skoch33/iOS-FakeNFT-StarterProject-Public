//
//  PriceFormatter.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 10.10.2023.
//

import Foundation

struct PriceFormatter {
    static let numberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        return numberFormatter
    }()

    static func formattedPrice(_ value: Decimal?, currency: String = "ETH") -> String {
        let format = "%@ %@"
        let number = NSDecimalNumber(decimal: value ?? 0.0)
        return String(format: format, PriceFormatter.numberFormatter.string(from: number) ?? "0", currency)
    }
}
