import Foundation

public struct StopWatchComponent: SendableComponent {
    public var currentTime: TimeInterval
    public var name: String

    public init(name: String) {
        self.currentTime = 0
        self.name = name
    }
}
