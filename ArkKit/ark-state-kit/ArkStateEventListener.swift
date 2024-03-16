//
//  ArkStateEventListener.swift
//  ArkKit
//
//  Created by Ryan Peh on 14/3/24.
//

import Foundation

struct ArkStateEventListener {
    private let arkECS: ArkECS
    private let arkEventManager: ArkEventManager

    init(arkECS: ArkECS, arkEventManager: ArkEventManager) {
        self.arkECS = arkECS
        self.arkEventManager = arkEventManager
    }

    func setUpListeners() {
    }
}
