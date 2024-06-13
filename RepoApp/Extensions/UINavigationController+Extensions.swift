
import SwiftUI

extension UINavigationController {
    func push<V: View>(_ view: V, animated: Bool = true) -> UIViewController {
        let viewController = Self.generateHostingController(view)
        pushViewController(viewController, animated: animated)

        return viewController
    }

    func present<V: View>(_ view: V, isFullScreen: Bool = false, animated: Bool = true) {
        let viewController = Self.generateHostingController(view)
        if isFullScreen {
            viewController.modalPresentationStyle = .fullScreen
        }
        present(viewController, animated: animated)
    }

    func removeViewController(_ controller: UIViewController.Type) {
        var viewControllersList = viewControllers
        if let index = viewControllersList.firstIndex(where: { $0.isKind(of: controller.self) }) {
            viewControllersList.remove(at: index)
            setViewControllers(viewControllersList, animated: true)
        }
    }

    func transparentNavigationBar() {
        // Make the navigation bar background clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }

    func restoreTransparentNavigationBar() {
        // Restore the navigation bar to default
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = nil
        navigationBar.isTranslucent = false
    }
}

extension UINavigationController {
    convenience init<V: View>(rootView: V) {
        let viewController = Self.generateHostingController(rootView)
        self.init(rootViewController: viewController)
    }
}

// MARK: - Helper

protocol TabbarDisplayableView: View {
    var isTabBarDisplayable: Bool { get }
}

extension TabbarDisplayableView {
    var isTabBarDisplayable: Bool { false }
}

protocol TabbarDisplayableUIView: UIViewController {
    var isTabBarDisplayable: Bool { get }
}

extension TabbarDisplayableUIView {
    var isTabBarDisplayable: Bool { false }
}

extension UINavigationController {
    fileprivate static func generateHostingController<V: View>(_ view: V) -> UIHostingController<V> {
        let hostingController = UIHostingController(
            rootView: view
        )

        if let displayable = view as? (any TabbarDisplayableView) {
            hostingController.hidesBottomBarWhenPushed = !displayable.isTabBarDisplayable
        } else {
            hostingController.hidesBottomBarWhenPushed = true
        }

        hostingController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        return hostingController
    }
}
