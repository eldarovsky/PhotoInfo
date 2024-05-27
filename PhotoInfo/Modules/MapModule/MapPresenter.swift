//
//  MapPresenter.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import YandexMapsMobile

protocol MapPresenterProtocol: AnyObject {
    func showPlace()
    func getTarget() -> YMKPoint
}

class MapPresenter {
    weak var view: MapViewControllerProtocol?
    let model: MapModel

    init(model: MapModel) {
        self.model = model
    }
}

extension MapPresenter: MapPresenterProtocol {
    func showPlace() {
        let position = model.position
        view?.showPlace(position: position)
    }

    func getTarget() -> YMKPoint {
        model.position.target
    }
}
