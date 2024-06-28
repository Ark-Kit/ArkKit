//
//  AbstractPannable.swift
//  ArkKit
//
//  Created by En Rong on 18/3/24.
//

import Foundation

public typealias PanEventDelegate = (_ angle: Double, _ magnitude: Double) -> Void

public protocol AbstractPannable {
    var onPanStartDelegate: PanEventDelegate? { get set }
    var onPanChangeDelegate: PanEventDelegate? { get set }
    var onPanEndDelegate: PanEventDelegate? { get set }
}

extension AbstractPannable {
    public func onPanStart(_ handler: @escaping PanEventDelegate) -> Self {
        guard onPanStartDelegate == nil else {
            assertionFailure("onPanStartDelegate has already been assigned!")
            return self
        }

        var newSelf = self
        newSelf.onPanStartDelegate = handler
        return newSelf
    }

    public func onPanChange(_ handler: @escaping PanEventDelegate) -> Self {
        guard onPanChangeDelegate == nil else {
            assertionFailure("onPanChangeDelegate has already been assigned!")
            return self
        }

        var newSelf = self
        newSelf.onPanChangeDelegate = handler
        return newSelf
    }

    public func onPanEnd(_ handler: @escaping PanEventDelegate) -> Self {
        guard onPanEndDelegate == nil else {
            assertionFailure("onPanEndDelegate has already been assigned!")
            return self
        }

        var newSelf = self
        newSelf.onPanEndDelegate = handler
        return newSelf
    }
}
