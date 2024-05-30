//
//  BaseCoordinator.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Base coordinator

/// A base class implementing the CoordinatorProtocol.
/// This class provides basic functionality for managing child coordinators.
class BaseCoordinator: CoordinatorProtocol {

    // MARK: - Public properties

    /// A collection of child coordinators.
    /// These coordinators are managed by the current coordinator.
    var childCoordinators: [CoordinatorProtocol] = []

    // MARK: - Public methods

    /// Starts the coordinator.
    /// This method should be overridden by subclasses to define their initial actions.
    /// By default, this method throws a fatal error to remind the developer to implement it.
    func start() {
        fatalError("Child should implement func Start")
    }

    /// Removes all child coordinators from the `childCoordinators` array.
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}
