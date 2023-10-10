//
//  UIView + Extension.swift
//  FakeNFT
//
//  Created by Semen Kocherga on 10.10.2023.
//

import UIKit

extension UIView {
    func setupView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
