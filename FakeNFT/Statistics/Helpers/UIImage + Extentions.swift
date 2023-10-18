//
//  ExtentionUIImage.swift
//  FakeNFT
//

import UIKit

enum Images: String {
    case chevron = "chevron.forward"
    case sortIcon = "sortIcon"
    case noActiveLike = "noActiveLike"
    case activeLike = "activeLike"
    case defaultStarIcon = "defaultStarIcon"
    case starDoneIcon = "starDoneIcon"
    case basketDark = "basketDark"
    case basketLight = "basketLight"
    case basketLightIsOrder = "basketLightIsOrder"
    case basketDarkIsOrder = "basketDarkIsOrder"
}

extension UIImage {
    static var placeholder: UIImage? { return UIImage(systemName: "person.crop.circle.fill")}
    static var chevron: UIImage? { return UIImage(named: Images.chevron.rawValue) }
    static var sortIcon: UIImage? { return UIImage(named: Images.sortIcon.rawValue) }
    static var noActiveLike: UIImage? { return UIImage(named: Images.noActiveLike.rawValue) }
    static var activeLike: UIImage? { return UIImage(named: Images.activeLike.rawValue) }
    static var defaultStarIcon: UIImage? { return UIImage(named: Images.defaultStarIcon.rawValue) }
    static var starDoneIcon: UIImage? { return UIImage(named: Images.starDoneIcon.rawValue) }
    static var basketDark: UIImage? { return UIImage(named: Images.basketDark.rawValue) }
    static var basketLight: UIImage? { return UIImage(named: Images.basketLight.rawValue) }
    static var basketLightIsOrder: UIImage? { return UIImage(named: Images.basketLightIsOrder.rawValue) }
    static var basketDarkIsOrder: UIImage? { return UIImage(named: Images.basketDarkIsOrder.rawValue) }
}
