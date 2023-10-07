import UIKit

final class CollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .nftWhite

        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .nftBlack
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem

    }

}
