@testable import ArkKit
import Foundation

class MockRootView: AbstractRootView {
    var abstractView: View
    init() {
        self.abstractView = 1
        self.size = CGSize(width: 0, height: 0)
    }
    func pushView(_ view: any ArkKit.AbstractView<View>, animated: Bool) {
    }

    var size: CGSize

    typealias View = Any
}
