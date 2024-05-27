//
//  ImageLoader.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 24.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError
    case invalidResponse
    case noData
}

protocol ImageLoaderProtocol {
    func loadImage(fromURL url: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class ImageLoader: ImageLoaderProtocol {

    func loadImage(fromURL url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
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
