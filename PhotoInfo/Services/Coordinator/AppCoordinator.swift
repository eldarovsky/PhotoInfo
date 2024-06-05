//
//  AppCoordinator.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

// MARK: - App coordinator

/// The main application coordinator.
/// This class is responsible for setting up the initial view controller and managing the flow of the app.
final class AppCoordinator: BaseCoordinator {

    // MARK: - Private properties

    /// The main window of the application.
    private let window: UIWindow

    /// The root navigation controller used for navigation.
    private let navigationController = UINavigationController()

    // MARK: - Initializers

    /// Initializes the app coordinator with a window.
    /// - Parameter window: The main window of the application.
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }

    // MARK: - Public methods

    /// Starts the app coordinator.
    /// This method sets up the initial view controller and begins the coordination process.
    override func start() {
        let infoViewControllerCoordinator = InfoViewControllerCoordinator(navigationController: navigationController)
        add(coordinator: infoViewControllerCoordinator)
        infoViewControllerCoordinator.start()
    }
}
