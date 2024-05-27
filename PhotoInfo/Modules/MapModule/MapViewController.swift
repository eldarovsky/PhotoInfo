//
//  MapViewController.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 24.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit
import YandexMapsMobile

protocol MapViewControllerProtocol: AnyObject {
    func showPlace(position: YMKCameraPosition)
}

final class MapViewController: UIViewController {

    // MARK: - Private properties

    private let mapView = YMKMapView()

    weak var mapViewControllerCoordinator: MapViewControllerCoordinator?
    var presenter: MapPresenterProtocol?

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.showPlace()
    }

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }

    private func setupView() {
        addSubviews()
        setupLayout()
        setupNavigationBar()
        addPlacemarkOnMap()
    }

    private func addSubviews() {
        view.addSubview(mapView)
    }

    private func setupLayout() {
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

    private func addPlacemarkOnMap() {
        let placemark = mapView.mapWindow.map.mapObjects.addPlacemark()

        guard let target = presenter?.getTarget() else { return }
        guard let icon = UIImage(systemName: "camera.fill") else { return }

        placemark.geometry = target
        placemark.setIconWith(icon)
    }
}

extension MapViewController: MapViewControllerProtocol {
    func showPlace(position: YMKCameraPosition) {
        mapView.mapWindow.map.move(
            with: position,
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }
}
