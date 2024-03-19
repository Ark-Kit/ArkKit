//
//  AbstractBitmap.swift
//  ArkKit
//
//  Created by En Rong on 19/3/24.
//

import Foundation

protocol AbstractBitmap {
    func clipToBounds() -> Self
    func scaleAspectFit() -> Self
    func scaleToFill() -> Self
    func scaleAspectFill() -> Self
}
