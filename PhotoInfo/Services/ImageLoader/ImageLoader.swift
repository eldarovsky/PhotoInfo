//
//  ImageLoader.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 24.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Image loader protocol

/// Protocol defining the requirements for an image loader.
protocol ImageLoaderProtocol {
    func loadImage(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

// MARK: - Image loader

final class ImageLoader: ImageLoaderProtocol {

    // MARK: - Public methods

    /// Loads an image from the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL string from which to load the image.
    ///   - completion: A completion handler that gets called with the result of the image loading operation.
    ///   The result can be either the image data or a `NetworkError`.
    func loadImage(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: imageURL)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let imageData = data else {
                completion(.failure(.noData))
                return
            }

            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }.resume()
    }
}
