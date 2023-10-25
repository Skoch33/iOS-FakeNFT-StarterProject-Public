//
//  String+Extensions.swift
//  FakeNFT
//
//  Created by Тимур Танеев on 18.10.2023.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
