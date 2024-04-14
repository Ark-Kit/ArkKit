import Foundation

protocol DisplayContext {
    var canvasSize: CGSize { get }
    var screenSize: CGSize { get }

    func updateScreenSize(_ newSize: CGSize)
}

class ArkDisplayContext: DisplayContext {
    private(set) var canvasSize: CGSize
    private(set) var screenSize: CGSize

    init(canvasSize: CGSize, screenSize: CGSize) {
        self.canvasSize = canvasSize
        self.screenSize = screenSize
    }

    func updateScreenSize(_ newSize: CGSize) {
        self.screenSize = newSize
    }
}
