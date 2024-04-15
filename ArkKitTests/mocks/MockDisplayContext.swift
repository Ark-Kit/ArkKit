import Foundation
@testable import ArkKit

class MockDisplayContext: DisplayContext {
    func updateScreenSize(_ newSize: CGSize) {
    }

    var canvasSize = CGSize.zero
    var screenSize = CGSize.zero
}
