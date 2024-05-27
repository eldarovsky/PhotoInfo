//
//  MapViewController.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 24.05.2024.
//

import UIKit
import YandexMapsMobile

final class MapViewController: UIViewController, MapViewProtocol {

    // MARK: - Private properties

    private let mapView = YMKMapView()
    private var presenter: MapPresenter?

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Initializers

    init(position: YMKCameraPosition) {
        let model = MapModel(position: position)
        super.init(nibName: nil, bundle: nil)
        self.presenter = MapPresenter(view: self, model: model)
        self.presenter?.showPlace(position: model.position)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - MapView

    func showPlace(position: YMKCameraPosition) {
        mapView.mapWindow.map.move(
            with: position,
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
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

        guard let target = presenter?.model.position.target else { return }
        placemark.geometry = target
        placemark.setIconWith(UIImage(systemName: "mappin")!)
    }
}
