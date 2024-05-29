//
//  AppCoordinator.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

// MARK: - App coordinator

final class AppCoordinator: BaseCoordinator {

    // MARK: - Private properties

    private var window: UIWindow

    private var navigationController = UINavigationController()

    // MARK: - Initializers

    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }

    // MARK: - Public methods

    override func start() {
        let infoViewControllerCoordinator = InfoViewControllerCoordinator(navigationController: navigationController)
        add(coordinator: infoViewControllerCoordinator)
        infoViewControllerCoordinator.start()
    }
}
