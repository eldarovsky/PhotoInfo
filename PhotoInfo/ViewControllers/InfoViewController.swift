//
//  InfoViewController.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 23.05.2024.
//

import UIKit
import PhotosUI
import YandexMapsMobile

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
    
    private let imageLoader: ImageLoader
    
    private var position: YMKCameraPosition?
    private var allDataString = ""
    private var imageData: Data?
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addActions()
        requestPhotoLibraryAccess()
    }
    
    // MARK: - Initializers
    
    init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    @objc private func pickImageFromWeb() {
        showLinkTextField()
    }
    
    @objc private func pickImageFromPhotos() {
        showPhotos()
    }
    
    @objc private func showImageLocation() {
        showLocation()
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
}

private extension InfoViewController {
    
    func addSubviews() {
        [imageView,
         activityIndicator,
         infoTextView,
         mapButton,
         greetingLabel].forEach { view.addSubview($0) }
    }
    
    func setupLayout() {
        [imageView,
         activityIndicator,
         infoTextView,
         mapButton,
         greetingLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints =  false }
        
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

private extension InfoViewController {
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.authorizationStatus()
        PHPhotoLibrary.requestAuthorization { _ in }
    }
    
    func showLinkTextField() {
        let alert = UIAlertController(title: "Insert direct image URL", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "URL"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            guard let textField = alert.textFields?.first else { return }
            guard let imageURL = textField.text, !imageURL.isEmpty else { return }
            
            self.imageLoader.loadImage(fromURL: imageURL) { result in
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
    
    func showPhotos() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    func showLocation() {
        guard let position = position else { return }
        let mapVC = MapViewController(position: position)
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func extractMetadata(from data: Data) {
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
                allDataString += "Date Time:  \(dateTimeOriginal)\n"
            }
            
            if let lensMake = exifData[kCGImagePropertyExifLensMake] {
                allDataString += "Lens Make:  \(lensMake)\n"
            }
            
            if let lensModel = exifData[kCGImagePropertyExifLensModel] {
                allDataString += "Lens Model:  \(lensModel)\n"
            }
            
            if let aperture = exifData[kCGImagePropertyExifApertureValue] as? Double {
                let aperture = String(format: "%.2f", aperture)
                allDataString += "Aperture:  \(aperture)\n"
            }
            
            if let focalLength = exifData[kCGImagePropertyExifFocalLength] {
                allDataString += "Focal Length (original):  \(focalLength)\n"
            }
            
            if let focalLenIn35mmFilm = exifData[kCGImagePropertyExifFocalLenIn35mmFilm] {
                allDataString += "Focal Length (in 35mm film):  \(focalLenIn35mmFilm)\n"
            }
            
            if let shutterSpeed = exifData[kCGImagePropertyExifShutterSpeedValue] as? Double {
                let formattedShutterSpeed = String(format: "%.2f", shutterSpeed)
                allDataString += "Shutter Speed:  \(formattedShutterSpeed)\n"
            }
            
            if let isoSpeedRatings = exifData[kCGImagePropertyExifISOSpeedRatings] as? [NSNumber] {
                if let iso = isoSpeedRatings.first {
                    allDataString += "ISO:  \(iso)\n"
                }
            }
            
            if let colorSpace = exifData[kCGImagePropertyExifColorSpace] as? NSNumber {
                let colorSpaceMapping: [Int: String] = [
                    1: "sRGB",
                    2: "Adobe RGB",
                    0xFFFF: "Uncalibrated"
                ]
                let colorSpaceString = colorSpaceMapping[colorSpace.intValue] ?? "Unknown"
                allDataString += "Color Space:  \(colorSpaceString)\n"
            }
        }
        
        // Извлечение IPTC
        if let iptc = metadata[kCGImagePropertyIPTCDictionary] as? [CFString: Any] {
            
            if let city = iptc[kCGImagePropertyIPTCCity] {
                allDataString += "City:  \(city)\n"
            }
            
            if let location = iptc[kCGImagePropertyIPTCSubLocation] {
                allDataString += "Location:  \(location)\n"
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
                self.infoTextView.text = "No metadata was found"
            } else {
                self.infoTextView.text = self.allDataString
            }
            
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    func setSign(side: String?) -> Double {
        guard let side = side else { return 1 }
        
        switch side.uppercased() {
        case "S", "W":
            return -1
        default:
            return 1
        }
    }
}

extension InfoViewController: PHPickerViewControllerDelegate {
    
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
                    self.imageData = imageData
                    DispatchQueue.main.async {
                        self.extractMetadata(from: imageData)
                        if let image = UIImage(data: imageData) {
                            self.imageView.image = image
                        }
                    }
                }
            }
        }
    }
}
