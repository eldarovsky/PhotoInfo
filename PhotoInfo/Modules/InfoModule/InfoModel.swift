//
//  InfoModel.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

// MARK: - Image metadata model

/// A model representing metadata associated with an image.
struct ImageMetadata {

    /// The original date and time when the image was taken.
    let dateTimeOriginal: String?

    /// The brand of the camera used to capture the image.
    let brand: String?

    /// The model of the camera used to capture the image.
    let model: String?

    /// The make of the lens used to capture the image.
    let lensMake: String?

    /// The model of the lens used to capture the image.
    let lensModel: String?

    /// The aperture setting used to capture the image.
    let aperture: String?

    /// The focal length used to capture the image.
    let focalLength: String?

    /// The focal length in 35mm film equivalent.
    let focalLenIn35mmFilm: String?

    /// The shutter speed used to capture the image.
    let shutterSpeed: String?

    /// The ISO sensitivity setting used to capture the image.
    let iso: String?

    /// The color space of the image.
    let colorSpace: String?

    /// The city where the image was taken.
    let city: String?

    /// The location where the image was taken.
    let location: String?

    /// The latitude where the image was taken.
    let latitude: Double?

    /// The longitude where the image was taken.
    let longitude: Double?

    /// Converts the metadata properties into a formatted string.
    ///
    /// - Returns: A string representation of the metadata.
    func toString() -> String {
        let metadataItems: [(String, String?)] = [
            ("Date Time", dateTimeOriginal),
            ("Brand", brand),
            ("Model", model),
            ("Lens Make", lensMake),
            ("Lens Model", lensModel),
            ("Aperture", aperture),
            ("Focal Length (original)", focalLength),
            ("Focal Length (in 35mm film)", focalLenIn35mmFilm),
            ("Shutter Speed", shutterSpeed),
            ("ISO", iso),
            ("Color Space", colorSpace),
            ("City", city),
            ("Location", location)
        ]

        let metadataStrings: [String] = metadataItems.compactMap { label, value in
            guard let value = value else { return nil }
            return "\(label): \(value)\n"
        }

        return metadataStrings.isEmpty ? "No metadata was found" : metadataStrings.joined()
    }
}
