//
//  CoordinatorProtocol.swift
//  PhotoInfo
//
//  Created by Eldar Abdullin on 27.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Coordinator protocol

/// A protocol defining the basic requirements for a coordinator.
/// A coordinator is responsible for controlling the flow of the application and managing the navigation.
protocol CoordinatorProtocol: AnyObject {

    /// A collection of child coordinators.
    /// These coordinators are managed by the current coordinator.
    var childCoordinators: [CoordinatorProtocol] { get set }

    /// Starts the coordinator.
    /// This method should be implemented to define the initial actions of the coordinator.
    func start ()
}

// MARK: - Coordinator protocol extension

extension CoordinatorProtocol {

    /// Adds a child coordinator to the `childCoordinators` array.
    ///
    /// - Parameter coordinator: The coordinator to be added.
    func add(coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }

    /// Removes a child coordinator from the `childCoordinators` array.
    ///
    /// - Parameter coordinator: The coordinator to be removed.
    func remove(coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
