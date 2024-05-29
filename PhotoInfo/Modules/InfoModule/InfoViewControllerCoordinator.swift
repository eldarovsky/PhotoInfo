//
//  InfoViewControllerCoordinator.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

// MARK: - Info view controller coordinator

final class InfoViewControllerCoordinator: BaseCoordinator {

    // MARK: - Private properties

    private var navigationController: UINavigationController

    // MARK: - Initializers

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public methods

    override func start() {
        let imageLoader = ImageLoader()
        let infoPresenter = InfoPresenter(imageLoader: imageLoader)
        let infoViewController = InfoViewController()

        infoPresenter.view = infoViewController
        infoViewController.presenter = infoPresenter

        infoPresenter.infoViewControllerCoordinator = self
        navigationController.pushViewController(infoViewController, animated: true)
    }

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
