//
//  SelectCoordinator.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import UIKit

class SelectCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    
    required init(parentCoordinator: Coordinator?, navigationController: UINavigationController?) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        // no-child
    }
}
