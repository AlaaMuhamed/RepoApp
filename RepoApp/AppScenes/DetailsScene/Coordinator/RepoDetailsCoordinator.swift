
import Foundation
import SwiftUI

final class RepoDetailsCoordinator: RouterCoordinator {
    
    weak var parentCoordinator: RouterCoordinator?
    var childCoordinators: [RouterCoordinator] = []
    let router: RouterProtocol
    let detailsViewModel: RepoDetailsViewModel?
    
    init(router: RouterProtocol, viewModel: RepoDetailsViewModel) {
        self.router = router
        detailsViewModel = viewModel
    }
    
    func start() {
        let repoDetailsView = RepoDetailsSceneView(repoDetailsCoordinator: self,
                                                   viewModel: detailsViewModel)
        router.hideNavigation(animated: false)
        router.push(repoDetailsView, onNavigateBack: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
    }
    
    func backToHome() {
        router.pop(animated: true)
    }
}
