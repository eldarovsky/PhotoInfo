//
//  MapViewControllerCoordinator.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 28.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit
import YandexMapsMobile

// MARK: - Map view controller coordinator

final class MapViewControllerCoordinator: BaseCoordinator {

    // MARK: - Private properties

    private let navigationController: UINavigationController
    private let model: MapModel

    // MARK: - Initializers

    init(navigationController: UINavigationController, model: MapModel) {
        self.navigationController = navigationController
        self.model = model
    }

    // MARK: - Public methods

    override func start() {
        let mapPresenter = MapPresenter(model: model)
        let mapViewController = MapViewController()

        mapPresenter.view = mapViewController
        mapViewController.presenter = mapPresenter

        mapPresenter.mapViewControllerCoordinator = self
        navigationController.pushViewController(mapViewController, animated: true)
    }
}
