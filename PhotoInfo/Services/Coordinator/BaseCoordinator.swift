//
//  BaseCoordinator.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Base coordinator

class BaseCoordinator: CoordinatorProtocol {

    // MARK: - Public properties

    var childCoordinators: [CoordinatorProtocol] = []

    // MARK: - Public methods

    func start() {
        fatalError("Child should implement func Start")
    }

    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}
