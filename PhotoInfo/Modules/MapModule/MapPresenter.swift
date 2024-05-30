//
//  MapPresenter.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import YandexMapsMobile

// MARK: - Map presenter protocol

/// Protocol defining the methods required by the MapPresenter.
protocol MapPresenterProtocol {

    /// Shows the location on the map.
    func showLocation()

    /// Retrieves the target point on the map.
    func getTarget() -> YMKPoint
}

// MARK: - Map presenter

/// Presenter responsible for handling map-related logic.
final class MapPresenter {

    // MARK: - Public properties

    /// Coordinator associated with the presenter.
    weak var mapViewControllerCoordinator: MapViewControllerCoordinator?

    /// The view associated with the presenter.
    weak var view: MapViewControllerProtocol?

    // MARK: - Private properties

    /// The model containing map data.
    private let model: MapModel

    // MARK: - Initializers

    /// Initializes the MapPresenter with a map model.
    /// - Parameter model: The map model.
    init(model: MapModel) {
        self.model = model
    }
}

// MARK: - Map presenter protocol methods

extension MapPresenter: MapPresenterProtocol {
    func showLocation() {
        let position = model.position
        view?.showLocation(position: position)
    }

    func getTarget() -> YMKPoint {
        model.position.target
    }
}
