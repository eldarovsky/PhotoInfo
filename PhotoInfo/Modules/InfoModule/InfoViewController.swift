//
//  InfoViewController.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 23.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit
import PhotosUI
import YandexMapsMobile

protocol InfoViewControllerProtocol: AnyObject {
    func displayImage(_ image: UIImage)
    func displayMetadata(_ metadata: String)
    func showActivityIndicator()
    func hideActivityIndicator()
    func updateGreetingLabel(isHidden: Bool)
    func setMapButtonVisibility(isHidden: Bool)
    func showAlert(with title: String, message: String)
    func showPhotoPicker(with configuration: PHPickerConfiguration)
}

final class InfoViewController: UIViewController {

    // MARK: - Private properties

    private let greetingLabel: UILabel = {
        let greetingLabel = UILabel()
        greetingLabel.text = "Tap buttons to start"
        return greetingLabel
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.tintColor = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let infoTextView: UITextView = {
        let infoTextView = UITextView()
        infoTextView.isEditable = false
        infoTextView.font = UIFont.systemFont(ofSize: 17)
        infoTextView.backgroundColor = .tertiarySystemGroupedBackground
        return infoTextView
    }()

    private let mapButton: UIButton = {
        let mapButton = UIButton()
        mapButton.isHidden = true
        mapButton.setTitle("Location", for: .normal)
        mapButton.setTitleColor(.gray, for: .highlighted)
        mapButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        mapButton.backgroundColor = .systemGreen
        mapButton.layer.cornerRadius = 8
        return mapButton
    }()

    var presenter: InfoPresenter?

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addActions()
        presenter?.requestPhotoLibraryAccess()
    }

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    @objc private func pickImageFromWeb() {
        presenter?.showLinkTextField()
    }

    @objc private func pickImageFromPhotos() {
        presenter?.showPhotos()
    }

    @objc private func showImageLocation() {
        presenter?.showLocation()
    }
}

private extension InfoViewController {

    func setupView() {
        view.backgroundColor = .tertiarySystemGroupedBackground

        addSubviews()
        setupLayout()
        setupNavigationBar()
    }

    func addActions() {
        mapButton.addTarget(self, action: #selector(showImageLocation), for: .touchUpInside)
    }

    func addSubviews() {
        [imageView, activityIndicator, infoTextView, mapButton, greetingLabel].forEach { view.addSubview($0) }
    }

    func setupLayout() {
        [imageView, activityIndicator, infoTextView, mapButton, greetingLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints =  false }

        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            mapButton.widthAnchor.constraint(equalToConstant: 90),
            mapButton.heightAnchor.constraint(equalToConstant: 35),
            mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            infoTextView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            infoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoTextView.bottomAnchor.constraint(equalTo: mapButton.topAnchor, constant: -20)
        ])
    }

    func setupNavigationBar() {
        let libraryPhotoButton = UIBarButtonItem(
            image: UIImage(systemName: "photo"),
            style: .plain,
            target: self,
            action: #selector(pickImageFromPhotos)
        )

        let webPhotoButton = UIBarButtonItem(
            image: UIImage(systemName: "link"),
            style: .plain,
            target: self,
            action: #selector(pickImageFromWeb)
        )

        libraryPhotoButton.tintColor = .black
        webPhotoButton.tintColor = .black

        navigationItem.rightBarButtonItems = [libraryPhotoButton, webPhotoButton]
    }
}

extension InfoViewController: InfoViewControllerProtocol {
    
    func displayImage(_ image: UIImage) {
        imageView.image = image
    }

    func displayMetadata(_ metadata: String) {
        infoTextView.text = metadata
    }

    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    func updateGreetingLabel(isHidden: Bool) {
        greetingLabel.isHidden = isHidden
    }

    func setMapButtonVisibility(isHidden: Bool) {
        mapButton.isHidden = isHidden
    }

    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "URL"
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let textField = alert.textFields?.first else { return }
            guard let imageURL = textField.text, !imageURL.isEmpty else { return }

            self.presenter?.loadImage(from: imageURL)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func showPhotoPicker(with configuration: PHPickerConfiguration) {
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self.presenter
        present(pickerViewController, animated: true)
    }
}
