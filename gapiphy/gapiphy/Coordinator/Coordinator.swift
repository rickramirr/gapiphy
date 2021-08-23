//
//  Coordinator.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 22/08/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = GIFGridView()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func viewGIFDetail(_ gif: GIF) {
        let vc = GIFDetailView()
        vc.coordinator = self
        vc.gif = gif
        navigationController.pushViewController(vc, animated: true)
    }
    
}
