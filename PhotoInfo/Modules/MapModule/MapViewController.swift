//
//  MapViewController.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 24.05.2024.
//

import UIKit
import YandexMapsMobile

final class MapViewController: UIViewController {

    // MARK: - Private properties

    private let mapView = YMKMapView()

    private var position: YMKCameraPosition

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Initializers

    init(position: YMKCameraPosition) {
        self.position = position
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
}

private extension MapViewController {

    func setupView() {
        addSubviews()
        setupLayout()
        setupNavigationBar()

        showPlace(position: position)
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
}
