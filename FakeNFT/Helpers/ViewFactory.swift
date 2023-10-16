import UIKit

final class ViewFactory {
    static let shared = ViewFactory()
    
    func createTextLabel() -> UILabel {
        let label = UILabel()
        label.font = .headline2
        return label
    }
    
    func createTextView() -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .bodyRegular
        textView.backgroundColor = .nftLightgrey
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 10)
        return textView
    }
    
    func createNFTImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }
    
    func createLikeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "favouritesIcons")
        return imageView
    }
}
