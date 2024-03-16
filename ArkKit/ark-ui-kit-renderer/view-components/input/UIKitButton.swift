//
//  UIKitButton.swift
//  ArkKit
//
//  Created by En Rong on 16/3/24.
//

import UIKit

class UIKitButton: UIView, UIKitRenderable, TapRenderable {
    var onTapDelegate: TapDelegate?

    init() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        super.init(frame: frame)

        // TODO: Update UIButton styling
        let button = UIButton()
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func handleTap() {
        if let unwrappedOnTapDelegate = onTapDelegate {
            unwrappedOnTapDelegate()
        }
    }
}
