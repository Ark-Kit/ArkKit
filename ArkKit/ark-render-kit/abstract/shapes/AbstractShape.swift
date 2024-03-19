//
//  AbstractShape.swift
//  ArkKit
//
//  Created by En Rong on 19/3/24.
//

import Foundation

protocol AbstractShape {
    // TODO: Update this color representation in the future
    // (e.g. provide a mapping at the adapter level CanvasRenderer)
    typealias Color = String

    func fill(color: Color) -> Self
    func stroke(lineWidth: Double, color: Color) -> Self
}
