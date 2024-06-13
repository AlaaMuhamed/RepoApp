

import Foundation
import UIKit

final class LoginCoordinator: RouterCoordinator {
    
    weak var parentCoordinator: RouterCoordinator?
    var childCoordinators: [RouterCoordinator] = []
    let router: RouterProtocol
        
    // MARK: - Initialization
    
    init(router: RouterProtocol) {
        self.router = router
    }
            
    func start() {
        let homeCoordinator = HomeCoordinator(router: router)
        homeCoordinator.start()
    }
    
   
    
}
