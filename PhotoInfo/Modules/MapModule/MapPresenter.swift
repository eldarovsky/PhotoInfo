//
//  MapPresenter.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 27.05.2024.
//

import UIKit
import YandexMapsMobile

protocol MapViewProtocol: AnyObject {
    func showPlace(position: YMKCameraPosition)
}

class MapPresenter {
    private weak var view: MapViewProtocol?
     let model: MapModel

    init(view: MapViewProtocol, model: MapModel) {
        self.view = view
        self.model = model
    }
}

extension MapPresenter: MapViewProtocol {
    func showPlace(position: YMKCameraPosition) {
        view?.showPlace(position: model.position)
    }
}
