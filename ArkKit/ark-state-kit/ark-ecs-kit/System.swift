//
//  System.swift
//  LevelKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

protocol System: AnyObject {
    var active: Bool { get set }

    func update(deltaTime: TimeInterval, arkECS: ArkECS)
}
