//
//  MapViewController.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 24.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit
import YandexMapsMobile

// MARK: - Map view controller protocol

/// Protocol defining the methods required by the MapViewController.
protocol MapViewControllerProtocol: AnyObject {

    /// Show the location on the map with the specified camera position.
    /// - Parameter position: The camera position to show on the map.
    func showLocation(position: YMKCameraPosition)
}

// MARK: - Map view controller

/// View controller responsible for displaying the map.
final class MapViewController: UIViewController {

    // MARK: - Public properties

    /// Presenter for the map view controller.
    var presenter: MapPresenterProtocol?

    // MARK: - Private properties

    /// The map view.
    private let mapView = YMKMapView()

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        showLocation()
    }

    // MARK: - Private methods

    /// Closes the view controller.
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }

    /// Shows the location on the map.
    private func showLocation() {
        presenter?.showLocation()
    }

    deinit {
        presenter?.finish()
    }
}

// MARK: - Private extensions

private extension MapViewController {

    /// Sets up the views.
    func setupViews() {
        addSubviews()
        setupLayout()
        setupNavigationBar()
        addPlacemarkOnMap()
    }

    /// Adds subviews.
    func addSubviews() {
        view.addSubview(mapView)
    }

    /// Sets up the layout constraints.
    func setupLayout() {
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /// Sets up the navigation bar.
    func setupNavigationBar() {
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

    /// Adds a placemark on the map.
    func addPlacemarkOnMap() {
        let placemark = mapView.mapWindow.map.mapObjects.addPlacemark()

        guard let target = presenter?.getTarget() else { return }
        guard let icon = UIImage(named: "PlacemarkIcon") else { return }

        placemark.geometry = target
        placemark.setIconWith(icon)
    }
}

// MARK: - Map view controller protocol methods

extension MapViewController: MapViewControllerProtocol {
    func showLocation(position: YMKCameraPosition) {
        mapView.mapWindow.map.move(
            with: position,
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }
}
