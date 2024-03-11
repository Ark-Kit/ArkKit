//
//  Component.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

typealias ComponentID = UUID

protocol Component {
    var entityID: EntityID { get set }
}
