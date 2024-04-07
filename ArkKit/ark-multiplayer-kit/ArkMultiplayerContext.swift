//
//  ArkMultiplayerContext.swift
//  ArkKit
//
//  Created by Ryan Peh on 7/4/24.
//

import Foundation

protocol ArkMultiplayerContext {
    var playerNumber: Int { get }
    var serviceName: String { get set }
}
