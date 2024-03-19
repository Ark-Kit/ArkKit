//
//  AbstractPannable.swift
//  ArkKit
//
//  Created by En Rong on 18/3/24.
//

import Foundation

typealias PanDelegate = (_ angle: Double, _ magnitude: Double) -> Void

protocol AbstractPannable {
    var onPanStartDelegate: PanDelegate? { get set }
    var onPanChangeDelegate: PanDelegate? { get set }
    var onPanEndDelegate: PanDelegate? { get set }

    /// To be implemented in the concrete implementor of the AbstractPannable protocol to support
    /// modification of fields to support the builder pattern. The respective fields should be set to that
    /// of all the input parameters.
    ///
    /// For example, structs should remain immutable by first creating a copy and modifying the fields
    /// on that copy. Class properties should be modified directly on the instance itself.
    func modify(
        onPanStartDelegate: PanDelegate?,
        onPanChangeDelegate: PanDelegate?,
        onPanEndDelegate: PanDelegate?
    ) -> Self
}

extension AbstractPannable {
    func addPanStartDelegate(delegate: @escaping PanDelegate) -> Self {
        guard onPanStartDelegate != nil else {
            assertionFailure("onPanStartDelegate has already been assigned!")
            return self
        }

        return upsert(onPanStartDelegate: delegate)
    }

    func addPanChangeDelegate(delegate: @escaping PanDelegate) -> Self {
        guard onPanChangeDelegate != nil else {
            assertionFailure("onPanChangeDelegate has already been assigned!")
            return self
        }

        return upsert(onPanChangeDelegate: delegate)
    }

    func addPanEndDelegate(delegate: @escaping PanDelegate) -> Self {
        guard onPanEndDelegate != nil else {
            assertionFailure("onPanEndDelegate has already been assigned!")
            return self
        }

        return upsert(onPanEndDelegate: delegate)
    }

    /// Calls the `modify` function while preserving the pre-existing non-nil fields in the concrete implementor.
    private func upsert(
        onPanStartDelegate: PanDelegate? = nil,
        onPanChangeDelegate: PanDelegate? = nil,
        onPanEndDelegate: PanDelegate? = nil
    ) -> Self {
        modify(
            onPanStartDelegate: onPanStartDelegate ?? self.onPanStartDelegate,
            onPanChangeDelegate: onPanChangeDelegate ?? self.onPanChangeDelegate,
            onPanEndDelegate: onPanEndDelegate ?? self.onPanEndDelegate
        )
    }
}
