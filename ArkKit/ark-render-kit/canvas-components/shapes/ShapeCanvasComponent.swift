//
//  ShapeCanvasComponent.swift
//  ArkKit
//
//  Created by En Rong on 19/3/24.
//

import Foundation

protocol ShapeCanvasComponent: AbstractShape, CanvasComponent {
    var fillInfo: ShapeFillInfo? { get }
    var strokeInfo: ShapeStrokeInfo? { get }

    func modify(fillInfo: ShapeFillInfo?, strokeInfo: ShapeStrokeInfo?) -> Self
}

extension ShapeCanvasComponent {
    func fill(color: String) -> Self {
        upsert(fillInfo: ShapeFillInfo(color: color))
    }

    func stroke(lineWidth: Double, color: String) -> Self {
        upsert(strokeInfo: ShapeStrokeInfo(lineWidth: lineWidth, color: color))
    }

    func upsert(fillInfo: ShapeFillInfo? = nil, strokeInfo: ShapeStrokeInfo? = nil) -> Self {
        modify(fillInfo: fillInfo ?? self.fillInfo, strokeInfo: strokeInfo ?? self.strokeInfo)
    }
}

struct ShapeFillInfo {
    let color: String
}

struct ShapeStrokeInfo {
    let lineWidth: Double
    let color: String
}
