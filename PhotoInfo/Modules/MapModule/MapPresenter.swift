//
//  MapPresenter.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import YandexMapsMobile

// MARK: - Map presenter protocol

protocol MapPresenterProtocol {
    func showLocation()
    func getTarget() -> YMKPoint
}

// MARK: - Map presenter

final class MapPresenter {

    // MARK: - Public properties

    weak var mapViewControllerCoordinator: MapViewControllerCoordinator?
    weak var view: MapViewControllerProtocol?

    // MARK: - Private properties

    private let model: MapModel

    // MARK: - Initializers

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
