//
//  InfoPresenter.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import PhotosUI
import YandexMapsMobile

// MARK: - Info presenter protocol

protocol InfoPresenterProtocol {
    func requestAccess()
    func showLinkTextField()
    func showPhotos()
    func showLocation()
    func loadImage(from url: String)
}

// MARK: - Info presenter

final class InfoPresenter {

    // MARK: - Public properties

    weak var infoViewControllerCoordinator: InfoViewControllerCoordinator?
    weak var view: InfoViewControllerProtocol?

    // MARK: - Private properties

    private let imageLoader: ImageLoader
    private var position: YMKCameraPosition?

    private let colorSpaceMapping = [1: "sRGB",
                                     2: "Adobe RGB",
                                     0xFFFF: "Uncalibrated"]

    // MARK: - Initializers

    init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
    }

    // MARK: - Private methods

    private func extractMetadata(from data: Data) {
        view?.showActivityIndicator()
        view?.hideGreetingLabel(isHidden: true)

        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return }
        guard let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else { return }

        let tiffData = metadata[kCGImagePropertyTIFFDictionary] as? [CFString: Any]
        let exifData = metadata[kCGImagePropertyExifDictionary] as? [CFString: Any]
        let iptcData = metadata[kCGImagePropertyIPTCDictionary] as? [CFString: Any]
        let gpsData = metadata[kCGImagePropertyGPSDictionary] as? [CFString: Any]

        let imageMetadata = ImageMetadata(
            dateTimeOriginal: exifData?[kCGImagePropertyExifDateTimeOriginal] as? String,
            brand: tiffData?[kCGImagePropertyTIFFMake] as? String,
            model: tiffData?[kCGImagePropertyTIFFModel] as? String,
            lensMake: exifData?[kCGImagePropertyExifLensMake] as? String,
            lensModel: exifData?[kCGImagePropertyExifLensModel] as? String,
            aperture: (exifData?[kCGImagePropertyExifApertureValue] as? Double).map {
                String(format: "%.2f", $0)
            },
            focalLength: exifData?[kCGImagePropertyExifFocalLength] as? String,
            focalLenIn35mmFilm: exifData?[kCGImagePropertyExifFocalLenIn35mmFilm] as? String,
            shutterSpeed: (exifData?[kCGImagePropertyExifShutterSpeedValue] as? Double).map {
                String(format: "%.2f", $0)
            },
            iso: (exifData?[kCGImagePropertyExifISOSpeedRatings] as? [NSNumber])?.first.map { $0.stringValue },
            colorSpace: (exifData?[kCGImagePropertyExifColorSpace] as? NSNumber).flatMap {
                colorSpaceMapping[$0.intValue] ?? "Unknown"
            },
            city: iptcData?[kCGImagePropertyIPTCCity] as? String,
            location: iptcData?[kCGImagePropertyIPTCSubLocation] as? String,
            latitude: (gpsData?[kCGImagePropertyGPSLatitude] as? Double).map {
                setSign(side: gpsData?[kCGImagePropertyGPSLatitudeRef] as? String) * $0
            },
            longitude: (gpsData?[kCGImagePropertyGPSLongitude] as? Double).map {
                setSign(side: gpsData?[kCGImagePropertyGPSLongitudeRef] as? String) * $0
            }
        )

        if let latitude = imageMetadata.latitude, let longitude = imageMetadata.longitude {
            position = YMKCameraPosition(
                target: YMKPoint(latitude: latitude, longitude: longitude),
                zoom: 15,
                azimuth: 0,
                tilt: 0
            )
            view?.setMapButtonVisibility(isHidden: false)
        } else {
            position = nil
            view?.setMapButtonVisibility(isHidden: true)
        }

        DispatchQueue.main.async {
            self.view?.displayMetadata(imageMetadata.toString())
            self.view?.hideActivityIndicator()
        }
    }

    private func setSign(side: String?) -> Double {
        guard let side = side else { return 1 }

        switch side.uppercased() {
        case "S", "W":
            return -1
        default:
            return 1
        }
    }
}

extension InfoPresenter: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else {
            print("Failed to load image")
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
                if let error = error {
                    print("Image load error: \(error)")
                    return
                }

                guard let self = self else { return }
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.extractMetadata(from: imageData)
                        if let image = UIImage(data: imageData) {
                            self.view?.displayImage(image)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Info presenter protocol methods

extension InfoPresenter: InfoPresenterProtocol {

    func requestAccess() {
        PHPhotoLibrary.authorizationStatus()
        PHPhotoLibrary.requestAuthorization { _ in }
    }

    func showLinkTextField() {
        view?.showAlert(with: "Enter direct image URL", message: "")
    }

    func showPhotos() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        view?.showPhotoPicker(with: configuration)
    }

    func showLocation() {
        guard let position = position else { return }
        let mapModel = MapModel(position: position)
        infoViewControllerCoordinator?.runMapView(model: mapModel)
    }

    func loadImage(from url: String) {
        imageLoader.loadImage(from: url) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let imageData):
                    self.view?.displayImage(UIImage(data: imageData) ?? UIImage())
                    self.extractMetadata(from: imageData)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
