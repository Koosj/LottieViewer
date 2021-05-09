//
//  AppCoordinator.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var navigationController: UINavigationController? { get set }
    
    init(parentCoordinator: Coordinator?, navigationController: UINavigationController?)
    
    func start()
}

final class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    
    var window: UIWindow?
    
    required init(parentCoordinator: Coordinator?, navigationController: UINavigationController?) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        guard let selectViewController = SelectViewController.instantiate(viewModel: SelectedAnimationViewModel()) else { return }
        
        let navigationController = UINavigationController(rootViewController: selectViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
}
