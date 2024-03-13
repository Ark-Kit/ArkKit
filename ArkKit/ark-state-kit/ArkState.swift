//
//  ArkState.swift
//  ArkKit
//
//  Created by Ryan Peh on 9/3/24.
//

import Foundation

class ArkState {
    private let arkECS: ArkECS
    // TODO: Add Event Queue

    init() {
        self.arkECS = ArkECS()
    }

    func update(deltaTime: TimeInterval) {
        arkECS.update(deltaTime: deltaTime)
    }

}
