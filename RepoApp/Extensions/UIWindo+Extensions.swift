
import Foundation
import UIKit


public extension UIWindow {
    static var key: UIWindow? {
        UIApplication.shared.windows.first { $0.isKeyWindow }
    }

    static var statusBarHeight: CGFloat? {
        key?.windowScene?.statusBarManager?.statusBarFrame.height
    }

    static var foregroundScene: UIWindowScene? {
        UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }

    static var size: CGSize? {
        key?.frame.size
    }
}

