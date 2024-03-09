//
//  System.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

protocol System: AnyObject {
    var entityManager: EntityManager { get set }
    var isActive: Bool { get set }

    init(entityManager: EntityManager)

    func update(deltaTime: TimeInterval)
}
