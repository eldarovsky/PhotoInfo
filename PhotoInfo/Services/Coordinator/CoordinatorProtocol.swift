//
//  CoordinatorProtocol.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Coordinator protocol

protocol CoordinatorProtocol: AnyObject {

    var childCoordinators: [CoordinatorProtocol] { get set }

    func start ()
}

// MARK: - Coordinator protocol extension

extension CoordinatorProtocol {

    func add(coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }

    func remove(coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
