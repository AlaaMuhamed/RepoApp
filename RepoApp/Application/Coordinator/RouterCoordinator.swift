
import UIKit

protocol UIViewControllerContainer: AnyObject {
    var controllerContainerdIn: UIViewController? { get }
}

extension UIViewController: UIViewControllerContainer {
    var controllerContainerdIn: UIViewController? {
        self
    }
}

protocol RouterCoordinator: AnyObject, UIViewControllerContainer {
    var childCoordinators: [RouterCoordinator] { get set }
    var router: RouterProtocol { get }

    func start()
}

extension RouterCoordinator {

    func childDidFinish(_ child: RouterCoordinator?) {
        for (index, coordinator) in childCoordinators.enumerated()
            where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }

    func pop() {
        router.pop(animated: true)
    }

    var controllerContainerdIn: UIViewController? {
        router.navigationController.topViewController
    }
}
