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

// MARK: - Info view controller protocol

/// Protocol defining methods to be implemented by the InfoViewController.
protocol InfoViewControllerProtocol: AnyObject {

    /// Display an image.
    /// - Parameter image: The image to be displayed.
    func displayImage(_ image: UIImage)

    /// Display metadata.
    /// - Parameter metadata: The metadata to be displayed.
    func displayMetadata(_ metadata: String)

    /// Show an activity indicator.
    func showActivityIndicator()

    /// Hide the activity indicator.
    func hideActivityIndicator()

    /// Hide the greeting label.
    /// - Parameter isHidden: A Boolean value that determines whether the label is hidden.
    func hideGreetingLabel(isHidden: Bool)

    /// Set the visibility of the map button.
    /// - Parameter isHidden: A Boolean value that determines whether the map button is hidden.
    func setMapButtonVisibility(isHidden: Bool)

    /// Show an alert with the given title and message.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    func showAlert(with title: String, message: String)

    /// Show a photo picker with the provided configuration.
    /// - Parameter configuration: The configuration for the photo picker.
    func showPhotoPicker(with configuration: PHPickerConfiguration)
}

// MARK: - Info view controller

/// View controller responsible for displaying information.
final class InfoViewController: UIViewController {

    // MARK: - Public properties

    /// Presenter for the info view controller.
    var presenter: InfoPresenterProtocol?

    // MARK: - Private properties

    /// Label displaying a greeting message.
    private let greetingLabel: UILabel = {
        let greetingLabel = UILabel()
        greetingLabel.text = "Tap buttons to start"
        return greetingLabel
    }()

    /// Image view displaying the selected image.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    /// Activity indicator indicating loading activity.
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.tintColor = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    /// Text view displaying metadata information.
    private let infoTextView: UITextView = {
        let infoTextView = UITextView()
        infoTextView.isEditable = false
        infoTextView.font = UIFont.systemFont(ofSize: 17)
        infoTextView.backgroundColor = .tertiarySystemGroupedBackground
        return infoTextView
    }()

    /// Button for displaying image location.
    private let locationButton: UIButton = {
        let locationButton = UIButton()
        locationButton.isHidden = true
        locationButton.setTitle("Location", for: .normal)
        locationButton.setTitleColor(.white, for: .normal)
        locationButton.setTitleColor(.systemGray5, for: .highlighted)
        locationButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        locationButton.backgroundColor = .systemGreen
        locationButton.layer.cornerRadius = 8
        locationButton.layer.shadowRadius = 8
        locationButton.layer.shadowOpacity = 0.15
        locationButton.layer.masksToBounds = false
        locationButton.layer.shadowColor = UIColor.black.cgColor
        locationButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        return locationButton
    }()

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addActions()
        requestPhotoLibraryAccess()
    }

    // MARK: - Private methods

    /// Action to pick an image from the web.
    @objc private func pickImageFromWeb() {
        presenter?.showLinkTextField()
    }

    /// Action to pick an image from the photo library.
    @objc private func pickImageFromPhotos() {
        presenter?.showPhotos()
    }

    /// Action to show the location of the image.
    @objc private func showImageLocation() {
        presenter?.showLocation()
    }
}

private extension InfoViewController {

    /// Setup initial views.
    func setupViews() {
        setupView()
        addSubviews()
        setupLayout()
        setupNavigationBar()
    }

    /// Add actions to UI elements.
    func addActions() {
        locationButton.addTarget(self, action: #selector(showImageLocation), for: .touchUpInside)
    }

    /// Request access to the photo library.
    func requestPhotoLibraryAccess() {
        presenter?.requestAccess()
    }
}

private extension InfoViewController {

    /// Setup the main view.
    func setupView() {
        view.backgroundColor = .tertiarySystemGroupedBackground
    }

    /// Add subviews to the main view.
    func addSubviews() {
        [
            imageView,
            activityIndicator,
            infoTextView,
            locationButton,
            greetingLabel
        ].forEach { view.addSubview($0) }
    }

    /// Setup layout constraints for subviews.
    func setupLayout() {
        [
            imageView,
            activityIndicator,
            infoTextView,
            locationButton,
            greetingLabel
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            locationButton.widthAnchor.constraint(equalToConstant: 90),
            locationButton.heightAnchor.constraint(equalToConstant: 35),
            locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            infoTextView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            infoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoTextView.bottomAnchor.constraint(equalTo: locationButton.topAnchor, constant: -20)
        ])
    }

    /// Setup navigation bar buttons.
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

// MARK: - Info view controller protocol methods

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

    func hideGreetingLabel(isHidden: Bool) {
        greetingLabel.isHidden = isHidden
    }

    func setMapButtonVisibility(isHidden: Bool) {
        locationButton.isHidden = isHidden
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
        pickerViewController.delegate = self.presenter as? PHPickerViewControllerDelegate
        present(pickerViewController, animated: true)
    }
}
