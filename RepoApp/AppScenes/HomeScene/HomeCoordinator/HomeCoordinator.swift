
import Foundation
import SwiftUI

final class HomeCoordinator: RouterCoordinator {
    weak var parentCoordinator: RouterCoordinator?
    var childCoordinators: [RouterCoordinator] = []
    let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func start() {
        let homeSceneView = HomeSceneView(homeCoordinator: self)
        router.hideNavigation(animated: false)
        router.push(homeSceneView, onNavigateBack: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
    }
    
    func backToLogin() {
        let loginSceneView = LoginSceneView(loginViewModel: LoginViewModel())
        router.present(loginSceneView, isFullScreen: true)
    }
    
    func routeToRepoDetails(repoDetails: RepoDataModel) {
        let viewModel = RepoDetailsViewModel()
        viewModel.repo = repoDetails
        let child = RepoDetailsCoordinator(router: router, viewModel: viewModel)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
    
}
