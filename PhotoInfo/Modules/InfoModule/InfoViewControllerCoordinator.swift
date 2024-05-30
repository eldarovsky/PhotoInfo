//
//  InfoViewControllerCoordinator.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

// MARK: - Info view controller coordinator

/// A coordinator responsible for managing the flow of the InfoViewController.
final class InfoViewControllerCoordinator: BaseCoordinator {

    // MARK: - Private properties

    /// The navigation controller used for presenting view controllers.
    private let navigationController: UINavigationController

    // MARK: - Initializers

    /// Initializes the coordinator with a navigation controller.
    ///
    /// - Parameter navigationController: The navigation controller to be used.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public methods

    /// Starts the coordinator by setting up the initial view controller and presenter.
    override func start() {
        let imageLoader = ImageLoader()
        let infoPresenter = InfoPresenter(imageLoader: imageLoader)
        let infoViewController = InfoViewController()

        infoPresenter.view = infoViewController
        infoViewController.presenter = infoPresenter

        infoPresenter.infoViewControllerCoordinator = self
        navigationController.pushViewController(infoViewController, animated: true)
    }

    /// Runs the map view with the provided model.
    ///
    /// - Parameter model: The model data for configuring the map view.
    func runMapView(model: MapModel) {
        removeAllChildCoordinators()

        let mapViewControllerCoordinator = MapViewControllerCoordinator(
            navigationController: navigationController,
            model: model
        )

        add(coordinator: mapViewControllerCoordinator)
        mapViewControllerCoordinator.start()
    }
}
