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

protocol MapViewControllerProtocol: AnyObject {
    func showLocation(position: YMKCameraPosition)
}

// MARK: - Map view controller

final class MapViewController: UIViewController {

    // MARK: - Public properties

    var presenter: MapPresenterProtocol?

    // MARK: - Private properties

    private let mapView = YMKMapView()

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        showLocation()
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

    private func showLocation() {
        presenter?.showLocation()
    }
}

private extension MapViewController {

    func setupViews() {
        addSubviews()
        setupLayout()
        setupNavigationBar()
        addPlacemarkOnMap()
    }
}

private extension MapViewController {

    func addSubviews() {
        view.addSubview(mapView)
    }

    func setupLayout() {
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

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

    func addPlacemarkOnMap() {
        let placemark = mapView.mapWindow.map.mapObjects.addPlacemark()

        guard let target = presenter?.getTarget() else { return }
        guard let icon = UIImage(systemName: "arrowshape.up.circle.fill") else { return }

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
