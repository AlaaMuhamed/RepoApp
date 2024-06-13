
import UIKit

typealias NavigationBackHandler = ()->()

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { self }
}
