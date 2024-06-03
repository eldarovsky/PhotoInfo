//
//  NetworkError.swift
//  PhotoInfo
//
//  Created by Эльдар Абдуллин on 03.06.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Network Error

/// Enumeration representing different network errors that can occur while loading an image.
enum NetworkError: Error {
    case invalidURL
    case networkError
    case invalidResponse
    case noData
}
