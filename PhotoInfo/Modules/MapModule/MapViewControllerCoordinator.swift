//
//  MapViewControllerCoordinator.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 28.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit
import YandexMapsMobile

protocol MapViewControllerCoordinatorProtocol {
    func finish()
}

// MARK: - Map view controller coordinator

/// Coordinator responsible for coordinating navigation to the map view.
final class MapViewControllerCoordinator: BaseCoordinator {

    // MARK: - Private properties

    /// The navigation controller used for navigation.
    private let navigationController: UINavigationController

    /// The model containing data for the map view.
    private let model: MapModel

    // MARK: - Initializers

    /// Initializes the coordinator with a navigation controller and a map model.
    /// - Parameters:
    ///   - navigationController: The navigation controller to use for navigation.
    ///   - model: The model containing data for the map view.
    init(navigationController: UINavigationController, model: MapModel) {
        self.navigationController = navigationController
        self.model = model
    }

    // MARK: - Public methods

    /// Starts the coordination process.
    override func start() {
        let mapPresenter = MapPresenter(model: model)
        let mapViewController = MapViewController()

        mapPresenter.view = mapViewController
        mapViewController.presenter = mapPresenter

        mapPresenter.mapViewControllerCoordinator = self
        navigationController.pushViewController(mapViewController, animated: true)
    }
}

extension MapViewControllerCoordinator: MapViewControllerCoordinatorProtocol {
    func finish() {
        remove(coordinator: self)
    }
}
