//
//  AbstractTappable.swift
//  ArkKit
//
//  Created by En Rong on 18/3/24.
//

import Foundation

typealias TapDelegate = () -> Void

protocol AbstractTappable {
    var onTapDelegate: TapDelegate? { get set }

    /// To be implemented in the concrete implementor of the AbstractTappable protocol to support
    /// modification of fields to support the builder pattern. The respective fields should be set to that
    /// of all the input parameters.
    ///
    /// For example, structs should remain immutable by first creating a copy and modifying the fields
    /// on that copy. Class properties should be modified directly on the instance itself.
    func modify(onTapDelegate: TapDelegate?) -> Self
}

extension AbstractTappable {
    func onTap(_ delegate: @escaping TapDelegate) -> Self {
        guard onTapDelegate == nil else {
            assertionFailure("onTapDelegate has already been assigned!")
            return self
        }

        return upsert(onTapDelegate: delegate)
    }

    /// Calls the `modify` function while preserving the pre-existing non-nil fields in the concrete implementor.
    private func upsert(onTapDelegate: TapDelegate? = nil) -> Self {
        modify(onTapDelegate: onTapDelegate ?? self.onTapDelegate)
    }
}
