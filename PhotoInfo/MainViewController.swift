//
//  MainViewController.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 23.05.2024.
//

import UIKit
import PhotosUI
import YandexMapsMobile

final class MainViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var mapButton: UIButton!
    @IBOutlet private weak var greetingLabel: UILabel!

    private var isMapButtonEnabled = true

    private var originalImageData: Data?
    private var position: YMKCameraPosition?
    var allDataString = ""
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        requestPhotoLibraryAccess()

        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.tintColor = .black

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        textView.isEditable = false

        mapButton.isHidden = isMapButtonEnabled
        mapButton.layer.cornerRadius = 8
    }

    private func setupNavigationBar() {
        let libraryPhotoButton = UIBarButtonItem(
            image: UIImage(systemName: "photo"),
            style: .plain,
            target: self,
            action: #selector(pickImage)
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

    private func requestPhotoLibraryAccess() {
        PHPhotoLibrary.authorizationStatus()
        PHPhotoLibrary.requestAuthorization { _ in }
    }

    private func configureImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }

    @objc private func pickImage() {
        configureImagePicker()
    }

    @objc private func pickImageFromWeb() {
        alert()
    }

    private func alert() {
        let alert = UIAlertController(title: "Insert image URL", message: "", preferredStyle: .alert)


        alert.addTextField { textField in
            textField.placeholder = "Place URL here"
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in

            guard let self = self else { return }
            guard let textField = alert.textFields?.first else { return }
            guard let imageURL = textField.text, !imageURL.isEmpty else { return }

            self.networkManager.fetchImage(fromURL: imageURL) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
                        self.imageView.image = UIImage(data: imageData)
                        self.extractMetadata(from: imageData)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    private func extractMetadata(from data: Data) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.greetingLabel.isHidden = true
        }

        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return }
        guard let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else { return }

        allDataString = ""

        // Извлечение Exif
        if let exifData = metadata[kCGImagePropertyExifDictionary] as? [CFString: Any] {

            if let dateTimeOriginal = exifData[kCGImagePropertyExifDateTimeOriginal] {
                allDataString += "Date Time: \(dateTimeOriginal)\n"
            }

            if let lensMake = exifData[kCGImagePropertyExifLensMake] {
                allDataString += "Lens Make: \(lensMake)\n"
            }

            if let lensModel = exifData[kCGImagePropertyExifLensModel] {
                allDataString += "Lens Model: \(lensModel)\n"
            }

            if let aperture = exifData[kCGImagePropertyExifApertureValue] as? Double {
                let aperture = String(format: "%.2f", aperture)
                allDataString += "Aperture: \(aperture)\n"
            }

            if let focalLength = exifData[kCGImagePropertyExifFocalLength] {
                allDataString += "Focal Length: \(focalLength)\n"
            }

            if let focalLenIn35mmFilm = exifData[kCGImagePropertyExifFocalLenIn35mmFilm] {
                allDataString += "Focal Lens In 35mm Film: \(focalLenIn35mmFilm)\n"
            }

            if let shutterSpeed = exifData[kCGImagePropertyExifShutterSpeedValue] as? Double {
                let formattedShutterSpeed = String(format: "%.2f", shutterSpeed)
                allDataString += "Shutter Speed: \(formattedShutterSpeed)\n"
            }

            if let isoSpeedRatings = exifData[kCGImagePropertyExifISOSpeedRatings] as? [NSNumber] {
                if let iso = isoSpeedRatings.first {
                    allDataString += "ISO: \(iso)\n"
                }
            }

            if let colorSpace = exifData[kCGImagePropertyExifColorSpace] as? NSNumber {
                let colorSpaceMapping: [Int: String] = [
                    1: "sRGB",
                    2: "Adobe RGB",
                    0xFFFF: "Uncalibrated"
                ]
                let colorSpaceString = colorSpaceMapping[colorSpace.intValue] ?? "Unknown"
                allDataString += "Color Space: \(colorSpaceString)\n"
            }
        }

        // Извлечение IPTC
        if let iptc = metadata[kCGImagePropertyIPTCDictionary] as? [CFString: Any] {

            if let city = iptc[kCGImagePropertyIPTCCity] {
                allDataString += "City: \(city)\n"
            }

            if let location = iptc[kCGImagePropertyIPTCSubLocation] {
                allDataString += "Location: \(location)\n"
            }
        }

        // Извлечение GPS
        if let gpsData = metadata[kCGImagePropertyGPSDictionary] as? [CFString: Any] {

            let latitudeRef = gpsData[kCGImagePropertyGPSLatitudeRef] as? String
            guard var latitude = gpsData[kCGImagePropertyGPSLatitude] as? Double else { return }
            latitude *= setSign(side: latitudeRef)

            let longitudeRef = gpsData[kCGImagePropertyGPSLongitudeRef] as? String
            guard var longitude = gpsData[kCGImagePropertyGPSLongitude] as? Double else { return }
            longitude *= setSign(side: longitudeRef)

            let imgDirection = gpsData[kCGImagePropertyGPSImgDirection] as? Double

            position = YMKCameraPosition(
                target: YMKPoint(latitude: latitude, longitude: longitude),
                zoom: 15,
                azimuth: Float(imgDirection ?? 0),
                tilt: 0
            )

            mapButton.isHidden = false

        } else {
            position = nil
            mapButton.isHidden = true
        }

        DispatchQueue.main.async {
            if self.allDataString.isEmpty {
                self.textView.text = "No metadata was found"
            } else {
                self.textView.text = self.allDataString
            }

            self.activityIndicator.stopAnimating()
        }

    }

    @IBAction private func showMap() {
        guard position != nil else { return }
        performSegue(withIdentifier: "location", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapVC = segue.destination as? MapViewController else { return }
        guard let point = position else { return }
        mapVC.set(position: point)
    }

    private func setSign(side: String?) -> Double {
        guard let side = side else { return 1.0 }

        switch side.uppercased() {
        case "S", "W":
            return -1
        default:
            return 1
        }
    }
}

extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else {
            print("Не удалось загрузить изображение")
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
                if let error = error {
                    print("Ошибка загрузки изображения: \(error)")
                    return
                }

                guard let self = self else { return }
                if let data = data {
                    self.originalImageData = data
                    DispatchQueue.main.async {
                        self.extractMetadata(from: data)
                        if let image = UIImage(data: data) {
                            self.imageView.image = image
                        }
                    }
                }
            }
        }
    }
}
