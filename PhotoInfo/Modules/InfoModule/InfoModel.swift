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
    let imgDirection: Double?

    func toString() -> String {
        var metadataString = ""

        if let dateTimeOriginal = dateTimeOriginal {
            metadataString += "Date Time: \(dateTimeOriginal)\n"
        }
        if let lensMake = lensMake {
            metadataString += "Lens Make: \(lensMake)\n"
        }
        if let lensModel = lensModel {
            metadataString += "Lens Model: \(lensModel)\n"
        }
        if let aperture = aperture {
            metadataString += "Aperture: \(aperture)\n"
        }
        if let focalLength = focalLength {
            metadataString += "Focal Length (original): \(focalLength)\n"
        }
        if let focalLenIn35mmFilm = focalLenIn35mmFilm {
            metadataString += "Focal Length (in 35mm film): \(focalLenIn35mmFilm)\n"
        }
        if let shutterSpeed = shutterSpeed {
            metadataString += "Shutter Speed: \(shutterSpeed)\n"
        }
        if let iso = iso {
            metadataString += "ISO: \(iso)\n"
        }
        if let colorSpace = colorSpace {
            metadataString += "Color Space: \(colorSpace)\n"
        }
        if let city = city {
            metadataString += "City: \(city)\n"
        }
        if let location = location {
            metadataString += "Location: \(location)\n"
        }

        return metadataString.isEmpty ? "No metadata was found" : metadataString
    }
}
