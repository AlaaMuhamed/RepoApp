
import SwiftUI

protocol RouterProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    var presentedController: UIViewController? { get }

    var navigationBarHidden: Bool { get }

    func push(_ drawable: Drawable, onNavigateBack: NavigationBackHandler?)
    func push(_ drawable: Drawable, animated: Bool, onNavigateBack: NavigationBackHandler?)
    func push<V: View>(_ view: V, onNavigateBack handler: NavigationBackHandler?)
    func push<V: View>(_ view: V, animated: Bool, onNavigateBack handler: NavigationBackHandler?)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func popToViewController(_ controller: UIViewController, animated: Bool)
    func popToViewController<V: UIViewController>(of type: V.Type, animated: Bool)

    func present(_ drawable: Drawable)
    func present(_ drawable: Drawable, animated: Bool)
    // Swift UI Equivalents
    func present<V: View>(_ view: V)
    func present<V: View>(_ view: V, isFullScreen: Bool)
    func present<V: View>(_ view: V, animated: Bool)
    func present<V: View>(_ view: V, isFullScreen: Bool, animated: Bool)


    func changeControllers(with controllers: [UIViewController], animated: Bool)
    func dismiss()
    func dismiss(animated: Bool, completion: (()->())?)

    func showNavigation(animated: Bool)
    func hideNavigation(animated: Bool)
}

extension RouterProtocol {

    var presentedController: UIViewController? {
        navigationController.presentedViewController
    }
}

// MARK: - Router

class Router: NSObject, RouterProtocol {

    let navigationController: UINavigationController
    private var handlers: [String: NavigationBackHandler] = [:]

    init(with navigation: UINavigationController) {
        navigationController = navigation
        super.init()
        navigationController.delegate = self
    }

    func push(_ drawable: Drawable,
              onNavigateBack handler: NavigationBackHandler?) {
        push(drawable, animated: true, onNavigateBack: handler)
    }

    func push<V>(_ view: V, onNavigateBack handler: NavigationBackHandler?) where V: View {
        push(view, animated: true, onNavigateBack: handler)
    }

    func push<V: View>(_ view: V,
                       animated: Bool,
                       onNavigateBack handler: NavigationBackHandler?) {
        let viewController = navigationController.push(view, animated: animated)
        if let handler {
            handlers.updateValue(handler, forKey: String(describing: viewController))
        }
    }

    func push(_ drawable: Drawable,
              animated: Bool,
              onNavigateBack handler: NavigationBackHandler?) {

        guard let viewController = drawable.viewController else {
            return
        }

        if let handler {
            handlers.updateValue(handler, forKey: viewController.description)
        }

        if let viewController = viewController as? (any TabbarDisplayableUIView) {
            viewController.hidesBottomBarWhenPushed = !viewController.isTabBarDisplayable
        } else {
            viewController.hidesBottomBarWhenPushed = true
        }

        navigationController.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }

    func popToViewController(_ controller: UIViewController, animated: Bool) {
        navigationController.popToViewController(controller, animated: animated)
    }

    func popToViewController<V: View>(_ view: V, animated: Bool) {
        guard let viewController = navigationController.viewControllers.first(where: {
            if $0 as? UIHostingController<V> != nil {
                return true
            }

            return false
        })
        else {
            return
        }

        navigationController.popToViewController(viewController, animated: animated)
    }

    func popToViewController<V: UIViewController>(of type: V.Type, animated: Bool) {
        guard let viewController = navigationController.viewControllers.first(where: { $0 is V }) else {
            return
        }
        navigationController.popToViewController(viewController, animated: animated)
    }

    func present(_ drawable: Drawable) {
        present(drawable, animated: true)
    }

    func present(_ drawable: Drawable, animated: Bool) {
        guard let viewController = drawable.viewController else {
            return
        }
        navigationController.present(viewController, animated: animated, completion: nil)
    }

    func present<V: View>(_ view: V) {
        present(view, animated: true)
    }

    func present<V: View>(_ view: V, isFullScreen: Bool) {
        present(view, isFullScreen: isFullScreen, animated: true)
    }

    func present<V: View>(_ view: V, animated: Bool) {
        present(view, isFullScreen: false, animated: animated)
    }

    func present<V: View>(_ view: V, isFullScreen: Bool, animated: Bool) {
        navigationController.present(view, isFullScreen: isFullScreen, animated: animated)
    }


    func changeControllers(with controllers: [UIViewController], animated: Bool) {
        navigationController.setViewControllers(controllers, animated: animated)
    }

    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }

    func dismiss(animated: Bool, completion: (()->())? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    func showNavigation(animated: Bool) {
        navigationController.setNavigationBarHidden(false, animated: animated)
    }

    func hideNavigation(animated: Bool) {
        navigationController.setNavigationBarHidden(true, animated: animated)
    }

    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = handlers.removeValue(forKey: viewController.description) else {
            return
        }
        closure()
    }
}

extension Router: UINavigationControllerDelegate {

    var navigationBarHidden: Bool {
        navigationController.isNavigationBarHidden
    }

    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(previousController)
        else { return }

        executeClosure(previousController)
    }
}
