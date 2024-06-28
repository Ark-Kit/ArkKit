import Foundation

public struct GravityComponent: Component {
    public var gravityVector: CGVector

    public init(gravityVector: CGVector) {
        self.gravityVector = gravityVector
    }
}
