//
//  MapViewController.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 24.05.2024.
//

import UIKit
import YandexMapsMobile

protocol MapViewControllerProtocol: AnyObject {
    func set(position: YMKCameraPosition)
}

final class MapViewController: UIViewController {

    @IBOutlet weak var mapView: YMKMapView!

    private var position: YMKCameraPosition!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .black

        showPlace(position: position)
        addPlacemarkOnMap()

        setupNavigationBar()
    }

    func showPlace(position: YMKCameraPosition) {
        mapView.mapWindow.map.move(
            with: position,
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }

    func addPlacemarkOnMap() {
        let placemark = mapView.mapWindow.map.mapObjects.addPlacemark()
        placemark.geometry = position.target
        placemark.setIconWith(UIImage(systemName: "mappin")!)

    }

    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true

        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(close)
        )

        closeButton.tintColor = .black

        navigationItem.rightBarButtonItem = closeButton
    }

    @objc private func close() {
        navigationController?.popViewController(animated: true)

    }
}

extension MapViewController: MapViewControllerProtocol {
    func set(position: YMKCameraPosition) {
        self.position = position
    }
}
