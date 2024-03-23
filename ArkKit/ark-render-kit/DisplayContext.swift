import Foundation

protocol DisplayContext {
    var canvasSize: CGSize { get }
    var screenSize: CGSize { get }
}

struct ArkDisplayContext {
    var canvasSize: CGSize
    var screenSize: CGSize
}
