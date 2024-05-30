//
//  InfoModel.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

// MARK: - Image metadata model

struct ImageMetadata {
    let dateTimeOriginal: String?

    let brand: String?
    let model: String?

    let lensMake: String?
    let lensModel: String?
    let aperture: String?
    let focalLength: String?
    let focalLenIn35mmFilm: String?
    let shutterSpeed: String?
    let iso: String?
    let colorSpace: String?
    let city: String?
    let location: String?
    let latitude: Double?
    let longitude: Double?

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
