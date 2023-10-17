import UIKit

extension UIFont {

    private enum NftFontNames {
        static let regular = "SFProText-Regular"
        static let medium = "SFProText-Medium"
        static let bold = "SFProText-Bold"
    }

    // Headline Fonts
    enum NftHeadlineFonts {
        static var large = UIFont(name: NftFontNames.bold, size: 34)
        static var medium = UIFont(name: NftFontNames.bold, size: 22)
    }

    // Body Fonts
    enum NftBodyFonts {
        static var regular = UIFont(name: NftFontNames.regular, size: 17)
        static var bold = UIFont(name: NftFontNames.bold, size: 17)
    }

    // Caption Fonts
    enum NftCaptionFonts {
        static var large = UIFont(name: NftFontNames.regular, size: 15)
        static var medium = UIFont(name: NftFontNames.regular, size: 13)
        static var small = UIFont(name: NftFontNames.medium, size: 10)
    }
}
