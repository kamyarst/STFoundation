//
//  Coordinator.swift
//  JointBudget
//
//  Created by Kamyar on 22/02/2023.
//

#if canImport(UIKit)

    import UIKit

    protocol Coordinator: AnyObject {
        var parent: Coordinator? { get set }
        var children: [Coordinator] { get set }
        var navigationController: UINavigationController { get set }

        func start()
    }
#endif
